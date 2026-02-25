import ranger.api
import subprocess
from ranger.api.commands import *

HOOK_INIT_OLD = ranger.api.hook_init


def hook_init(fm):
    def update_zoxide(signal):
        subprocess.call(["zoxide", "add", signal.new.path])

    fm.signal_bind('cd', update_zoxide)
    HOOK_INIT_OLD(fm)


ranger.api.hook_init = hook_init


class j(Command):
    """:j

    Uses zoxide to set the current directory.
    """

    def execute(self):
        directory = subprocess.check_output(["zoxide", "query", "--", self.arg(1)])
        directory = directory.decode("utf-8", "ignore")
        directory = directory.rstrip('\n')
        self.fm.execute_console("cd " + directory)
