#!/usr/bin/env python3
import os
import re
import subprocess
from argparse import ArgumentParser


class Subcommand(object):
    def __init__(self, command, description, args, switches):
        self.command = command
        self.description = description
        self.args = args
        self.switches = switches


class Switch(object):
    def __init__(self, shorts, longs, description, metavar):
        self.shorts = shorts
        self.longs = longs
        self.description = description
        self.metavar = metavar

    def is_file_target(self):
        if not self.metavar:
            return False
        return self.metavar == 'FILE' or 'PATH' in self.metavar or 'pathname' in self.metavar

    @property
    def fish_completion(self):
        complete_arg_spec = ['-s %s' % x for x in self.shorts]
        complete_arg_spec += ['-l %s' % x for x in self.longs]
        if not self.is_file_target():
            complete_arg_spec.append('-f')
        desc = repr(self.description)
        return '''{0} -d {1}'''.format(' '.join(complete_arg_spec), desc)


class podmanCmdLine(object):
    binary = 'podman'

    def __init__(self, podman_path):
        self.podman_path = podman_path

    def get_output(self, *args):
        cmd = [os.path.join(self.podman_path, self.binary)] + list(args)
        ps = subprocess.Popen(cmd,
                              stdout=subprocess.PIPE,
                              stderr=subprocess.STDOUT)
        out, _ = ps.communicate()
        out = out.decode('utf-8')
        return iter(out.splitlines())

    def parse_switch(self, line):
        line = line.strip()
        if '  ' not in line:
            # ignore continuation lines
            return None
        opt, description = re.split('  +', line, 1)
        switches = opt.split(', ')
        metavar = None
        # handle arguments with metavar
        for i, switch in enumerate(switches):
            if ' ' in switch:
                switches[i], metavar = switch.split(' ', 1)
        shorts = [x[1:] for x in switches if not x.startswith('--')]
        longs = [x[2:] for x in switches if x.startswith('--')]
        return Switch(shorts, longs, description, metavar)

    def common_options(self):
        lines = self.get_output('-h')
        # skip header
        while next(lines) != 'Flags:':
            pass

        for line in lines:
            if line == 'Available Commands:':
                break
            switch = self.parse_switch(line)
            if switch:
                yield switch

    def subcommands(self):
        lines = self.get_output('help')
        while next(lines) != 'Available Commands:':
            pass

        for line in lines:
            if not line:
                break
            command, description = line.strip().split(None, 1)
            yield self.subcommand(command, description)

    def subcommand(self, command, description):
        lines = self.get_output('help', command)
        usage = None
        for line in lines:
            if line.startswith('Usage:'):
                usage = line
                break
        else:
            raise RuntimeError("Can't find Usage in command: %r" % command)
        args = usage.split()[3:]
        if args and args[0].upper() == '[OPTIONS]':
            args = args[1:]
        if command in ('push', 'pull'):
            # improve completion for podman push/pull
            args = ['REPOSITORY|IMAGE']
        elif command == 'images':
            args = ['REPOSITORY']
        switches = []
        for line in lines:
            if not line.strip().startswith('-'):
                continue
            switches.append(self.parse_switch(line))
        return Subcommand(command, description, args, switches)


class BaseFishGenerator(object):
    header_text = ''

    def __init__(self, podman):
        self.podman = podman

    def generate(self):
        self.header()
        self.common_options()
        self.subcommands()

    def header(self):
        cmds = sorted(sub.command for sub in self.podman.subcommands())
        print(self.header_text.lstrip() % ' '.join(cmds))

    def common_options(self):
        print('# common options')
        for switch in self.podman.common_options():
            print(
                '''complete -c {binary} -n '__fish_podman_no_subcommand' {completion}'''
                .format(binary=self.podman.binary,
                        completion=switch.fish_completion))
        print()

    def subcommands(self):
        print('# subcommands')
        for sub in self.podman.subcommands():
            print('# %s' % sub.command)
            desc = repr(sub.description)
            print(
                '''complete -c {binary} -f -n '__fish_podman_no_subcommand' -a {command} -d {desc}'''
                .format(binary=self.podman.binary,
                        command=sub.command,
                        desc=desc))
            for switch in sub.switches:
                if switch is None:
                    continue
                print(
                    '''complete -c {binary} -A -n '__fish_seen_subcommand_from {command}' {completion}'''
                    .format(binary=self.podman.binary,
                            command=sub.command,
                            completion=switch.fish_completion))

            # standalone arguments
            unique = set()
            for args in sub.args:
                m = re.match(r'\[(.+)\.\.\.\]', args)
                if m:
                    # optional arguments
                    args = m.group(1)
                unique.update(args.split('|'))
            for arg in sorted(unique):
                self.process_subcommand_arg(sub, arg)
            print()
        print()

    def process_subcommand_arg(self, sub, arg):
        pass


class podmanFishGenerator(BaseFishGenerator):
    header_text = """
# podman.fish - podman completions for fish shell
#
# To install the completions:
# mkdir -p ~/.config/fish/completions
# cp podman.fish ~/.config/fish/completions

function __fish_podman_no_subcommand --description 'Test if podman has yet to be given the subcommand'
    for i in (commandline -opc)
        if contains -- $i %s
            return 1
        end
    end
    return 0
end

function __fish_print_podman_containers --description 'Print a list of podman containers' -a select
    switch $select
        case running
            podman ps --no-trunc --filter status=running --format '{{.ID}}\\n{{.Names}}' | tr ',' '\\n'
        case stopped
            podman ps --no-trunc --filter status=exited --filter status=created --format '{{.ID}}\\n{{.Names}}' | tr ',' '\\n'
        case all
            podman ps --no-trunc --all --format '{{.ID}}\\n{{.Names}}' | tr ',' '\\n'
    end
end

function __fish_print_podman_images --description 'Print a list of podman images'
    podman images --format '{{if eq .Repository "<none>"}}{{.ID}}\\tUnnamed Image{{else}}{{.Repository}}:{{.Tag}}{{end}}'
end

function __fish_print_podman_repositories --description 'Print a list of podman repositories'
    podman images --format '{{.Repository}}' | command grep -v '<none>' | command sort | command uniq
end
"""

    def process_subcommand_arg(self, sub, arg):
        if arg == 'CONTAINER' or arg == '[CONTAINER...]':
            if sub.command in ('start', 'rm'):
                select = 'stopped'
            elif sub.command in ('commit', 'diff', 'export', 'inspect'):
                select = 'all'
            else:
                select = 'running'
            print(
                '''complete -c podman -A -f -n '__fish_seen_subcommand_from {0}' -a '(__fish_print_podman_containers {1})' -d "Container"'''
                .format(sub.command, select))
        elif arg == 'IMAGE':
            print(
                '''complete -c podman -A -f -n '__fish_seen_subcommand_from {0}' -a '(__fish_print_podman_images)' -d "Image"'''
                .format(sub.command))
        elif arg == 'REPOSITORY':
            print(
                '''complete -c podman -A -f -n '__fish_seen_subcommand_from {0}' -a '(__fish_print_podman_repositories)' -d "Repository"'''
                .format(sub.command))


def main():
    parser = ArgumentParser()
    parser.add_argument('--podman-path', default='/usr/bin')
    args = parser.parse_args()

    podmanFishGenerator(podmanCmdLine(args.podman_path)).generate()


if __name__ == '__main__':
    main()
