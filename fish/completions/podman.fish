# podman.fish - podman completions for fish shell
#
# To install the completions:
# mkdir -p ~/.config/fish/completions
# cp podman.fish ~/.config/fish/completions

function __fish_podman_no_subcommand --description 'Test if podman has yet to be given the subcommand'
    for i in (commandline -opc)
        if contains -- $i attach build commit container cp create diff events exec export generate healthcheck help history image images import info inspect kill load login logout logs mount pause play pod port ps pull push restart rm rmi run save search start stats stop system tag top umount unpause varlink version volume wait
            return 1
        end
    end
    return 0
end

function __fish_print_podman_containers --description 'Print a list of podman containers' -a select
    switch $select
        case running
            podman ps --no-trunc --filter status=running --format '{{.ID}}\n{{.Names}}' | tr ',' '\n'
        case stopped
            podman ps --no-trunc --filter status=exited --filter status=created --format '{{.ID}}\n{{.Names}}' | tr ',' '\n'
        case all
            podman ps --no-trunc --all --format '{{.ID}}\n{{.Names}}' | tr ',' '\n'
    end
end

function __fish_print_podman_images --description 'Print a list of podman images'
    podman images --format '{{if eq .Repository "<none>"}}{{.ID}}\tUnnamed Image{{else}}{{.Repository}}:{{.Tag}}{{end}}'
end

function __fish_print_podman_repositories --description 'Print a list of podman repositories'
    podman images --format '{{.Repository}}' | command grep -v '<none>' | command sort | command uniq
end

# common options
complete -c podman -n '__fish_podman_no_subcommand' -l cgroup-manager -f -d 'Cgroup manager to use (cgroupfs or systemd, default systemd)'
complete -c podman -n '__fish_podman_no_subcommand' -l cni-config-dir -f -d 'Path of the configuration directory for CNI networks'
complete -c podman -n '__fish_podman_no_subcommand' -l config -f -d 'Path of a libpod config file detailing container server configuration options'
complete -c podman -n '__fish_podman_no_subcommand' -l conmon -f -d 'Path of the conmon binary'
complete -c podman -n '__fish_podman_no_subcommand' -l cpu-profile -f -d 'Path for the cpu profiling results'
complete -c podman -n '__fish_podman_no_subcommand' -l default-mounts-file -f -d 'Path to default mounts file'
complete -c podman -n '__fish_podman_no_subcommand' -s h -l help -f -d 'help for podman'
complete -c podman -n '__fish_podman_no_subcommand' -l hooks-dir -f -d 'Set the OCI hooks directory path (may be set multiple times)'
complete -c podman -n '__fish_podman_no_subcommand' -l log-level -f -d 'Log messages above specified level: debug, info, warn, error, fatal or panic (default "error")'
complete -c podman -n '__fish_podman_no_subcommand' -l namespace -f -d 'Set the libpod namespace, used to create separate views of the containers and pods on the system'
complete -c podman -n '__fish_podman_no_subcommand' -l network-cmd-path -f -d 'Path to the command for configuring the network'
complete -c podman -n '__fish_podman_no_subcommand' -l root -f -d 'Path to the root directory in which data, including images, is stored'
complete -c podman -n '__fish_podman_no_subcommand' -l runroot -f -d "Path to the 'run directory' where all state information is stored"
complete -c podman -n '__fish_podman_no_subcommand' -l runtime -f -d 'Path to the OCI-compatible binary used to run containers, default is /usr/bin/runc'
complete -c podman -n '__fish_podman_no_subcommand' -l storage-driver -f -d 'Select which storage driver is used to manage storage of images and containers (default is overlay)'
complete -c podman -n '__fish_podman_no_subcommand' -l storage-opt -f -d 'Used to pass an option to the storage driver'
complete -c podman -n '__fish_podman_no_subcommand' -l syslog -f -d 'Output logging information to syslog as well as the console'
complete -c podman -n '__fish_podman_no_subcommand' -l tmpdir -f -d 'Path to the tmp directory'
complete -c podman -n '__fish_podman_no_subcommand' -l trace -f -d 'enable opentracing output'
complete -c podman -n '__fish_podman_no_subcommand' -l version -f -d 'version for podman'

# subcommands
# attach
complete -c podman -f -n '__fish_podman_no_subcommand' -a attach -d 'Attach to a running container'
complete -c podman -A -n '__fish_seen_subcommand_from attach' -l detach-keys -f -d 'Override the key sequence for detaching a container. Format is a single character [a-Z] or ctrl-<value> where <value> is one of: a-z, @, ^, [, , or _'
complete -c podman -A -n '__fish_seen_subcommand_from attach' -s h -l help -f -d 'help for attach'
complete -c podman -A -n '__fish_seen_subcommand_from attach' -s l -l latest -f -d 'Act on the latest container podman is aware of'
complete -c podman -A -n '__fish_seen_subcommand_from attach' -l no-stdin -f -d 'Do not attach STDIN. The default is false'
complete -c podman -A -n '__fish_seen_subcommand_from attach' -l sig-proxy -f -d 'Proxy received signals to the process (default true)'

# build
complete -c podman -f -n '__fish_podman_no_subcommand' -a build -d 'Build an image using instructions from Dockerfiles'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l add-host -f -d 'add a custom host-to-IP mapping (host:ip) (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l annotation -f -d 'Set metadata for an image (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l authfile -f -d 'path of the authentication file. Default is ${XDG_RUNTIME_DIR}/containers/auth.json'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l build-arg -f -d 'argument=value to supply to the builder'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l cache-from -f -d 'Images to utilise as potential cache sources. The build process does not currently support caching so this is a NOOP.'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l cap-add -f -d 'add the specified capability when running (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l cap-drop -f -d 'drop the specified capability when running (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l cert-dir -f -d 'use certificates at the specified path to access the registry'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l cgroup-parent -f -d 'optional parent cgroup for the container'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l cni-plugin-path -f -d 'path of CNI network plugins (default "/usr/libexec/cni:/opt/cni/bin")'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l compress -f -d 'This is legacy option, which has no effect on the image'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l cpu-period -f -d 'limit the CPU CFS (Completely Fair Scheduler) period'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l cpu-quota -f -d 'limit the CPU CFS (Completely Fair Scheduler) quota'
complete -c podman -A -n '__fish_seen_subcommand_from build' -s c -l cpu-shares -f -d 'CPU shares (relative weight)'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l cpuset-cpus -f -d 'CPUs in which to allow execution (0-3, 0,1)'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l cpuset-mems -f -d 'memory nodes (MEMs) in which to allow execution (0-3, 0,1). Only effective on NUMA systems.'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l creds -f -d 'use [username[:password]] for accessing the registry'
complete -c podman -A -n '__fish_seen_subcommand_from build' -s D -l disable-compression -f -d "don't compress layers by default (default true)"
complete -c podman -A -n '__fish_seen_subcommand_from build' -l disable-content-trust -f -d 'This is a Docker specific option and is a NOOP'
complete -c podman -A -n '__fish_seen_subcommand_from build' -s f -l file -d 'pathname or URL of a Dockerfile'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l force-rm -f -d 'Always remove intermediate containers after a build, even if the build is unsuccessful. (default true)'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l format -f -d 'format of the built image\'s manifest and metadata. Use BUILDAH_FORMAT environment variable to override. (default "oci")'
complete -c podman -A -n '__fish_seen_subcommand_from build' -s h -l help -f -d 'help for build'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l iidfile -f -d 'file to write the image ID to'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l ipc -f -d "'container', path of IPC namespace to join, or 'host'"
complete -c podman -A -n '__fish_seen_subcommand_from build' -l isolation -f -d 'type of process isolation to use. Use BUILDAH_ISOLATION environment variable to override. (default "oci")'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l label -f -d 'Set metadata for an image (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l layers -f -d 'cache intermediate layers during build. Use BUILDAH_LAYERS environment variable to override. (default true)'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l logfile -f -d 'log to file instead of stdout/stderr'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l loglevel -f -d 'adjust logging level (range from -2 to 3)'
complete -c podman -A -n '__fish_seen_subcommand_from build' -s m -l memory -f -d 'memory limit (format: <number>[<unit>], where unit = b, k, m or g)'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l memory-swap -f -d "swap limit equal to memory plus swap: '-1' to enable unlimited swap"
complete -c podman -A -n '__fish_seen_subcommand_from build' -l network -f -d "'container', path of network namespace to join, or 'host'"
complete -c podman -A -n '__fish_seen_subcommand_from build' -l no-cache -f -d 'Do not use existing cached images for the container build. Build from the start with a new set of cached layers.'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l pid -f -d "container, path of PID namespace to join, or 'host'"
complete -c podman -A -n '__fish_seen_subcommand_from build' -l platform -f -d 'CLI compatibility: no action or effect'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l pull -f -d 'pull the image if not present (default true)'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l pull-always -f -d 'pull the image, even if a version is present'
complete -c podman -A -n '__fish_seen_subcommand_from build' -s q -l quiet -f -d 'refrain from announcing build instructions and image read/write progress'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l rm -f -d 'Remove intermediate containers after a successful build (default true)'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l runtime-flag -f -d 'add global flags for the container runtime'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l security-opt -f -d 'security options (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l shm-size -f -d 'size of \'/dev/shm\'. The format is <number><unit>. (default "65536k")'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l signature-policy -d 'pathname of signature policy file (not usually used)'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l squash -f -d 'Squash newly built layers into a single new layer.'
complete -c podman -A -n '__fish_seen_subcommand_from build' -s t -l tag -f -d 'tagged name to apply to the built image'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l target -f -d 'set the target build stage to build'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l tls-verify -f -d 'require HTTPS and verify certificates when accessing the registry (default true)'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l ulimit -f -d 'ulimit options (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l userns -f -d "'container', path of user namespace to join, or 'host'"
complete -c podman -A -n '__fish_seen_subcommand_from build' -l userns-gid-map -f -d 'containerID:hostID:length GID mapping to use in user namespace'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l userns-gid-map-group -f -d 'name of entries from /etc/subgid to use to set user namespace GID mapping'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l userns-uid-map -f -d 'containerID:hostID:length UID mapping to use in user namespace'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l userns-uid-map-user -f -d 'name of entries from /etc/subuid to use to set user namespace UID mapping'
complete -c podman -A -n '__fish_seen_subcommand_from build' -l uts -f -d "container, :path of UTS namespace to join, or 'host'"
complete -c podman -A -n '__fish_seen_subcommand_from build' -s v -l volume -f -d 'bind mount a volume into the container (default [])'

# commit
complete -c podman -f -n '__fish_podman_no_subcommand' -a commit -d 'Create new image based on the changed container'
complete -c podman -A -n '__fish_seen_subcommand_from commit' -s a -l author -f -d 'Set the author for the image committed'
complete -c podman -A -n '__fish_seen_subcommand_from commit' -s c -l change -f -d 'Apply the following possible instructions to the created image (default []): CMD | ENTRYPOINT | ENV | EXPOSE | LABEL | ONBUILD | STOPSIGNAL | USER | VOLUME | WORKDIR'
complete -c podman -A -n '__fish_seen_subcommand_from commit' -s f -l format -f -d 'Format of the image manifest and metadata (default "oci")'
complete -c podman -A -n '__fish_seen_subcommand_from commit' -s h -l help -f -d 'help for commit'
complete -c podman -A -n '__fish_seen_subcommand_from commit' -s m -l message -f -d 'Set commit message for imported image'
complete -c podman -A -n '__fish_seen_subcommand_from commit' -s p -l pause -f -d 'Pause container during commit'
complete -c podman -A -n '__fish_seen_subcommand_from commit' -s q -l quiet -f -d 'Suppress output'

# container
complete -c podman -f -n '__fish_podman_no_subcommand' -a container -d 'Manage Containers'
complete -c podman -A -n '__fish_seen_subcommand_from container' -s h -l help -f -d 'help for container'

# cp
complete -c podman -f -n '__fish_podman_no_subcommand' -a cp -d 'Copy files/folders between a container and the local filesystem'
complete -c podman -A -n '__fish_seen_subcommand_from cp' -l extract -f -d 'Extract the tar file into the destination directory.'
complete -c podman -A -n '__fish_seen_subcommand_from cp' -s h -l help -f -d 'help for cp'

# create
complete -c podman -f -n '__fish_podman_no_subcommand' -a create -d 'Create but do not start a container'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l add-host -f -d 'Add a custom host-to-IP mapping (host:ip) (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l annotation -f -d 'Add annotations to container (key:value) (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from create' -s a -l attach -f -d 'Attach to STDIN, STDOUT or STDERR (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l blkio-weight -f -d 'Block IO weight (relative weight) accepts a weight value between 10 and 1000.'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l blkio-weight-device -f -d 'Block IO weight (relative device weight, format: DEVICE_NAME:WEIGHT)'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l cap-add -f -d 'Add capabilities to the container'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l cap-drop -f -d 'Drop capabilities from the container'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l cgroup-parent -f -d 'Optional parent cgroup for the container'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l cidfile -f -d 'Write the container ID to the file'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l conmon-pidfile -f -d 'Path to the file that will receive the PID of conmon'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l cpu-period -f -d 'Limit the CPU CFS (Completely Fair Scheduler) period'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l cpu-quota -f -d 'Limit the CPU CFS (Completely Fair Scheduler) quota'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l cpu-rt-period -f -d 'Limit the CPU real-time period in microseconds'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l cpu-rt-runtime -f -d 'Limit the CPU real-time runtime in microseconds'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l cpu-shares -f -d 'CPU shares (relative weight)'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l cpus -f -d 'Number of CPUs. The default is 0.000 which means no limit'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l cpuset-cpus -f -d 'CPUs in which to allow execution (0-3, 0,1)'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l cpuset-mems -f -d 'Memory nodes (MEMs) in which to allow execution (0-3, 0,1). Only effective on NUMA systems.'
complete -c podman -A -n '__fish_seen_subcommand_from create' -s d -l detach -f -d 'Run container in background and print container ID'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l detach-keys -f -d 'Override the key sequence for detaching a container. Format is a single character [a-Z] or `ctrl-<value>` where `<value>` is one of: `a-z`, `@`, `^`, `[`, `\\`, `]`, `^` or `_`'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l device -f -d 'Add a host device to the container (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l device-read-bps -f -d 'Limit read rate (bytes per second) from a device (e.g. --device-read-bps=/dev/sda:1mb)'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l device-read-iops -f -d 'Limit read rate (IO per second) from a device (e.g. --device-read-iops=/dev/sda:1000)'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l device-write-bps -f -d 'Limit write rate (bytes per second) to a device (e.g. --device-write-bps=/dev/sda:1mb)'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l device-write-iops -f -d 'Limit write rate (IO per second) to a device (e.g. --device-write-iops=/dev/sda:1000)'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l dns -f -d 'Set custom DNS servers'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l dns-opt -f -d 'Set custom DNS options'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l dns-search -f -d 'Set custom DNS search domains'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l entrypoint -f -d 'Overwrite the default ENTRYPOINT of the image'
complete -c podman -A -n '__fish_seen_subcommand_from create' -s e -l env -f -d 'Set environment variables in container'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l env-file -f -d 'Read in a file of environment variables'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l expose -f -d 'Expose a port or a range of ports (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l gidmap -f -d 'GID map to use for the user namespace'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l group-add -f -d 'Add additional groups to join (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l healthcheck-command -f -d "set a healthcheck command for the container ('none' disables the existing healthcheck)"
complete -c podman -A -n '__fish_seen_subcommand_from create' -l healthcheck-interval -f -d 'set an interval for the healthchecks (a value of disable results in no automatic timer setup) (default "30s")'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l healthcheck-retries -f -d 'the number of retries allowed before a healthcheck is considered to be unhealthy (default 3)'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l healthcheck-start-period -f -d 'the initialization time needed for a container to bootstrap (default "0s")'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l healthcheck-timeout -f -d 'the maximum time allowed to complete the healthcheck before an interval is considered failed (default "30s")'
complete -c podman -A -n '__fish_seen_subcommand_from create' -s h -l hostname -f -d 'Set container hostname'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l image-volume -f -d 'Tells podman how to handle the builtin image volumes. The options are: \'bind\', \'tmpfs\', or \'ignore\' (default "bind")'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l init -f -d 'Run an init binary inside the container that forwards signals and reaps processes'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l init-path -f -d 'Path to the container-init binary (default: "/usr/libexec/podman/catatonit")'
complete -c podman -A -n '__fish_seen_subcommand_from create' -s i -l interactive -f -d 'Keep STDIN open even if not attached'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l ip -f -d 'Specify a static IPv4 address for the container'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l ipc -f -d 'IPC namespace to use'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l kernel-memory -f -d 'Kernel memory limit (format: <number>[<unit>], where unit = b, k, m or g)'
complete -c podman -A -n '__fish_seen_subcommand_from create' -s l -l label -f -d 'Set metadata on container (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l label-file -f -d 'Read in a line delimited file of labels (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l log-driver -f -d 'Logging driver for the container'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l log-opt -f -d 'Logging driver options (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l mac-address -f -d 'Container MAC address (e.g. 92:d0:c6:0a:29:33), not currently supported'
complete -c podman -A -n '__fish_seen_subcommand_from create' -s m -l memory -f -d 'Memory limit (format: <number>[<unit>], where unit = b, k, m or g)'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l memory-reservation -f -d 'Memory soft limit (format: <number>[<unit>], where unit = b, k, m or g)'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l memory-swap -f -d "Swap limit equal to memory plus swap: '-1' to enable unlimited swap"
complete -c podman -A -n '__fish_seen_subcommand_from create' -l memory-swappiness -f -d 'Tune container memory swappiness (0 to 100, or -1 for system default) (default -1)'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l mount -f -d 'Attach a filesystem mount to the container (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l name -f -d 'Assign a name to the container'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l net -f -d 'Connect a container to a network (default "slirp4netns")'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l network -f -d 'Connect a container to a network (default "slirp4netns")'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l no-hosts -f -d 'Do not create /etc/hosts within the container, instead use the version from the image'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l oom-kill-disable -f -d 'Disable OOM Killer'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l oom-score-adj -f -d "Tune the host's OOM preferences (-1000 to 1000)"
complete -c podman -A -n '__fish_seen_subcommand_from create' -l pid -f -d 'PID namespace to use'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l pids-limit -f -d 'Tune container pids limit (set -1 for unlimited)'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l pod -f -d 'Run container in an existing pod'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l privileged -f -d 'Give extended privileges to container'
complete -c podman -A -n '__fish_seen_subcommand_from create' -s p -l publish -f -d "Publish a container's port, or a range of ports, to the host (default [])"
complete -c podman -A -n '__fish_seen_subcommand_from create' -s P -l publish-all -f -d 'Publish all exposed ports to random ports on the host interface'
complete -c podman -A -n '__fish_seen_subcommand_from create' -s q -l quiet -f -d 'Suppress output information when pulling images'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l read-only -f -d 'Make containers root filesystem read-only'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l restart -f -d 'Restart is not supported.  Please use a systemd unit file for restart'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l rm -f -d 'Remove container (and pod if created) after exit'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l rootfs -f -d 'The first argument is not an image but the rootfs to the exploded container'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l security-opt -f -d 'Security Options (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l shm-size -f -d 'Size of /dev/shm. The format is `<number><unit>` (default "65536k")'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l stop-signal -f -d 'Signal to stop a container. Default is SIGTERM'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l stop-timeout -f -d 'Timeout (in seconds) to stop a container. Default is 10 (default 10)'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l subgidname -f -d 'Name of range listed in /etc/subgid for use in user namespace'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l subuidname -f -d 'Name of range listed in /etc/subuid for use in user namespace'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l sysctl -f -d 'Sysctl options (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l systemd -f -d 'Run container in systemd mode if the command executable is systemd or init (default true)'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l tmpfs -f -d 'Mount a temporary filesystem (tmpfs) into a container (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from create' -s t -l tty -f -d 'Allocate a pseudo-TTY for container'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l uidmap -f -d 'UID map to use for the user namespace'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l ulimit -f -d 'Ulimit options (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from create' -s u -l user -f -d 'Username or UID (format: <name|uid>[:<group|gid>])'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l userns -f -d 'User namespace to use'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l uts -f -d 'UTS namespace to use'
complete -c podman -A -n '__fish_seen_subcommand_from create' -s v -l volume -f -d 'Bind mount a volume into the container (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from create' -l volumes-from -f -d 'Mount volumes from the specified container(s) (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from create' -s w -l workdir -f -d 'Working directory inside the container'

# diff
complete -c podman -f -n '__fish_podman_no_subcommand' -a diff -d "Inspect changes on container's file systems"
complete -c podman -A -n '__fish_seen_subcommand_from diff' -l format -f -d 'Change the output format'
complete -c podman -A -n '__fish_seen_subcommand_from diff' -s h -l help -f -d 'help for diff'

# events
complete -c podman -f -n '__fish_podman_no_subcommand' -a events -d 'show podman events'
complete -c podman -A -n '__fish_seen_subcommand_from events' -l filter -f -d 'filter output'
complete -c podman -A -n '__fish_seen_subcommand_from events' -l format -f -d 'format the output using a Go template'
complete -c podman -A -n '__fish_seen_subcommand_from events' -s h -l help -f -d 'help for events'
complete -c podman -A -n '__fish_seen_subcommand_from events' -l since -f -d 'show all events created since timestamp'
complete -c podman -A -n '__fish_seen_subcommand_from events' -l until -f -d 'show all events until timestamp'

# exec
complete -c podman -f -n '__fish_podman_no_subcommand' -a exec -d 'Run a process in a running container'
complete -c podman -A -n '__fish_seen_subcommand_from exec' -s e -l env -f -d 'Set environment variables'
complete -c podman -A -n '__fish_seen_subcommand_from exec' -s h -l help -f -d 'help for exec'
complete -c podman -A -n '__fish_seen_subcommand_from exec' -s i -l interactive -f -d 'Not supported.  All exec commands are interactive by default'
complete -c podman -A -n '__fish_seen_subcommand_from exec' -s l -l latest -f -d 'Act on the latest container podman is aware of'
complete -c podman -A -n '__fish_seen_subcommand_from exec' -l preserve-fds -f -d 'Pass N additional file descriptors to the container'
complete -c podman -A -n '__fish_seen_subcommand_from exec' -l privileged -f -d 'Give the process extended Linux capabilities inside the container.  The default is false'
complete -c podman -A -n '__fish_seen_subcommand_from exec' -s t -l tty -f -d 'Allocate a pseudo-TTY. The default is false'
complete -c podman -A -n '__fish_seen_subcommand_from exec' -s u -l user -f -d 'Sets the username or UID used and optionally the groupname or GID for the specified command'
complete -c podman -A -n '__fish_seen_subcommand_from exec' -s w -l workdir -f -d 'Working directory inside the container'

# export
complete -c podman -f -n '__fish_podman_no_subcommand' -a export -d "Export container's filesystem contents as a tar archive"
complete -c podman -A -n '__fish_seen_subcommand_from export' -s h -l help -f -d 'help for export'
complete -c podman -A -n '__fish_seen_subcommand_from export' -s o -l output -f -d 'Write to a specified file (default: stdout, which must be redirected)'

# generate
complete -c podman -f -n '__fish_podman_no_subcommand' -a generate -d 'Generated structured data'
complete -c podman -A -n '__fish_seen_subcommand_from generate' -s h -l help -f -d 'help for generate'

# healthcheck
complete -c podman -f -n '__fish_podman_no_subcommand' -a healthcheck -d 'Manage Healthcheck'
complete -c podman -A -n '__fish_seen_subcommand_from healthcheck' -s h -l help -f -d 'help for healthcheck'

# help
complete -c podman -f -n '__fish_podman_no_subcommand' -a help -d 'Help about any command'
complete -c podman -A -n '__fish_seen_subcommand_from help' -s h -l help -f -d 'help for help'
complete -c podman -A -n '__fish_seen_subcommand_from help' -l cgroup-manager -f -d 'Cgroup manager to use (cgroupfs or systemd, default systemd)'
complete -c podman -A -n '__fish_seen_subcommand_from help' -l cni-config-dir -f -d 'Path of the configuration directory for CNI networks'
complete -c podman -A -n '__fish_seen_subcommand_from help' -l config -f -d 'Path of a libpod config file detailing container server configuration options'
complete -c podman -A -n '__fish_seen_subcommand_from help' -l conmon -f -d 'Path of the conmon binary'
complete -c podman -A -n '__fish_seen_subcommand_from help' -l cpu-profile -f -d 'Path for the cpu profiling results'
complete -c podman -A -n '__fish_seen_subcommand_from help' -l default-mounts-file -f -d 'Path to default mounts file'
complete -c podman -A -n '__fish_seen_subcommand_from help' -l hooks-dir -f -d 'Set the OCI hooks directory path (may be set multiple times)'
complete -c podman -A -n '__fish_seen_subcommand_from help' -l log-level -f -d 'Log messages above specified level: debug, info, warn, error, fatal or panic (default "error")'
complete -c podman -A -n '__fish_seen_subcommand_from help' -l namespace -f -d 'Set the libpod namespace, used to create separate views of the containers and pods on the system'
complete -c podman -A -n '__fish_seen_subcommand_from help' -l network-cmd-path -f -d 'Path to the command for configuring the network'
complete -c podman -A -n '__fish_seen_subcommand_from help' -l root -f -d 'Path to the root directory in which data, including images, is stored'
complete -c podman -A -n '__fish_seen_subcommand_from help' -l runroot -f -d "Path to the 'run directory' where all state information is stored"
complete -c podman -A -n '__fish_seen_subcommand_from help' -l runtime -f -d 'Path to the OCI-compatible binary used to run containers, default is /usr/bin/runc'
complete -c podman -A -n '__fish_seen_subcommand_from help' -l storage-driver -f -d 'Select which storage driver is used to manage storage of images and containers (default is overlay)'
complete -c podman -A -n '__fish_seen_subcommand_from help' -l storage-opt -f -d 'Used to pass an option to the storage driver'
complete -c podman -A -n '__fish_seen_subcommand_from help' -l syslog -f -d 'Output logging information to syslog as well as the console'
complete -c podman -A -n '__fish_seen_subcommand_from help' -l tmpdir -f -d 'Path to the tmp directory'
complete -c podman -A -n '__fish_seen_subcommand_from help' -l trace -f -d 'enable opentracing output'

# history
complete -c podman -f -n '__fish_podman_no_subcommand' -a history -d 'Show history of a specified image'
complete -c podman -A -n '__fish_seen_subcommand_from history' -l format -f -d 'Change the output to JSON or a Go template'
complete -c podman -A -n '__fish_seen_subcommand_from history' -s h -l help -f -d 'help for history'
complete -c podman -A -n '__fish_seen_subcommand_from history' -s H -l human -f -d 'Display sizes and dates in human readable format (default true)'
complete -c podman -A -n '__fish_seen_subcommand_from history' -l no-trunc -f -d 'Do not truncate the output'
complete -c podman -A -n '__fish_seen_subcommand_from history' -s q -l quiet -f -d 'Display the numeric IDs only'

# image
complete -c podman -f -n '__fish_podman_no_subcommand' -a image -d 'Manage images'
complete -c podman -A -n '__fish_seen_subcommand_from image' -s h -l help -f -d 'help for image'

# images
complete -c podman -f -n '__fish_podman_no_subcommand' -a images -d 'List images in local storage'
complete -c podman -A -n '__fish_seen_subcommand_from images' -s a -l all -f -d 'Show all images (default hides intermediate images)'
complete -c podman -A -n '__fish_seen_subcommand_from images' -l digests -f -d 'Show digests'
complete -c podman -A -n '__fish_seen_subcommand_from images' -s f -l filter -f -d 'Filter output based on conditions provided (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from images' -l format -f -d 'Change the output format to JSON or a Go template'
complete -c podman -A -n '__fish_seen_subcommand_from images' -s h -l help -f -d 'help for images'
complete -c podman -A -n '__fish_seen_subcommand_from images' -l no-trunc -f -d 'Do not truncate output'
complete -c podman -A -n '__fish_seen_subcommand_from images' -s n -l noheading -f -d 'Do not print column headings'
complete -c podman -A -n '__fish_seen_subcommand_from images' -s q -l quiet -f -d 'Display only image IDs'
complete -c podman -A -n '__fish_seen_subcommand_from images' -l sort -f -d 'Sort by created, id, repository, size, or tag (default "created")'
complete -c podman -A -f -n '__fish_seen_subcommand_from images' -a '(__fish_print_podman_repositories)' -d "Repository"

# import
complete -c podman -f -n '__fish_podman_no_subcommand' -a import -d 'Import a tarball to create a filesystem image'
complete -c podman -A -n '__fish_seen_subcommand_from import' -s c -l change -f -d 'Apply the following possible instructions to the created image (default []): CMD | ENTRYPOINT | ENV | EXPOSE | LABEL | STOPSIGNAL | USER | VOLUME | WORKDIR'
complete -c podman -A -n '__fish_seen_subcommand_from import' -s h -l help -f -d 'help for import'
complete -c podman -A -n '__fish_seen_subcommand_from import' -s m -l message -f -d 'Set commit message for imported image'
complete -c podman -A -n '__fish_seen_subcommand_from import' -s q -l quiet -f -d 'Suppress output'

# info
complete -c podman -f -n '__fish_podman_no_subcommand' -a info -d 'Display podman system information'
complete -c podman -A -n '__fish_seen_subcommand_from info' -s D -l debug -f -d 'Display additional debug information'
complete -c podman -A -n '__fish_seen_subcommand_from info' -s f -l format -f -d 'Change the output format to JSON or a Go template'
complete -c podman -A -n '__fish_seen_subcommand_from info' -s h -l help -f -d 'help for info'

# inspect
complete -c podman -f -n '__fish_podman_no_subcommand' -a inspect -d 'Display the configuration of a container or image'
complete -c podman -A -n '__fish_seen_subcommand_from inspect' -s f -l format -f -d 'Change the output format to a Go template'
complete -c podman -A -n '__fish_seen_subcommand_from inspect' -s h -l help -f -d 'help for inspect'
complete -c podman -A -n '__fish_seen_subcommand_from inspect' -s l -l latest -f -d 'Act on the latest container podman is aware of (containers only)'
complete -c podman -A -n '__fish_seen_subcommand_from inspect' -s s -l size -f -d 'Display total file size (containers only)'
complete -c podman -A -n '__fish_seen_subcommand_from inspect' -s t -l type -f -d 'Return JSON for specified type, (image or container) (default "all")'

# kill
complete -c podman -f -n '__fish_podman_no_subcommand' -a kill -d 'Kill one or more running containers with a specific signal'
complete -c podman -A -n '__fish_seen_subcommand_from kill' -s a -l all -f -d 'Signal all running containers'
complete -c podman -A -n '__fish_seen_subcommand_from kill' -s h -l help -f -d 'help for kill'
complete -c podman -A -n '__fish_seen_subcommand_from kill' -s l -l latest -f -d 'Act on the latest container podman is aware of'
complete -c podman -A -n '__fish_seen_subcommand_from kill' -s s -l signal -f -d 'Signal to send to the container (default "KILL")'

# load
complete -c podman -f -n '__fish_podman_no_subcommand' -a load -d 'Load an image from container archive'
complete -c podman -A -n '__fish_seen_subcommand_from load' -s h -l help -f -d 'help for load'
complete -c podman -A -n '__fish_seen_subcommand_from load' -s i -l input -f -d 'Read from specified archive file (default: stdin)'
complete -c podman -A -n '__fish_seen_subcommand_from load' -s q -l quiet -f -d 'Suppress the output'
complete -c podman -A -n '__fish_seen_subcommand_from load' -l signature-policy -f -d 'Pathname of signature policy file (not usually used)'

# login
complete -c podman -f -n '__fish_podman_no_subcommand' -a login -d 'Login to a container registry'
complete -c podman -A -n '__fish_seen_subcommand_from login' -l authfile -f -d 'Path of the authentication file. Default is ${XDG_RUNTIME_DIR}/containers/auth.json. Use REGISTRY_AUTH_FILE environment variable to override'
complete -c podman -A -n '__fish_seen_subcommand_from login' -l cert-dir -f -d 'Pathname of a directory containing TLS certificates and keys used to connect to the registry'
complete -c podman -A -n '__fish_seen_subcommand_from login' -l get-login -f -d 'Return the current login user for the registry (default true)'
complete -c podman -A -n '__fish_seen_subcommand_from login' -s h -l help -f -d 'help for login'
complete -c podman -A -n '__fish_seen_subcommand_from login' -s p -l password -f -d 'Password for registry'
complete -c podman -A -n '__fish_seen_subcommand_from login' -l password-stdin -f -d 'Take the password from stdin'
complete -c podman -A -n '__fish_seen_subcommand_from login' -l tls-verify -f -d 'Require HTTPS and verify certificates when contacting registries (default true)'
complete -c podman -A -n '__fish_seen_subcommand_from login' -s u -l username -f -d 'Username for registry'

# logout
complete -c podman -f -n '__fish_podman_no_subcommand' -a logout -d 'Logout of a container registry'
complete -c podman -A -n '__fish_seen_subcommand_from logout' -s a -l all -f -d 'Remove the cached credentials for all registries in the auth file'
complete -c podman -A -n '__fish_seen_subcommand_from logout' -l authfile -f -d 'Path of the authentication file. Default is ${XDG_RUNTIME_DIR}/containers/auth.json. Use REGISTRY_AUTH_FILE environment variable to override'
complete -c podman -A -n '__fish_seen_subcommand_from logout' -s h -l help -f -d 'help for logout'

# logs
complete -c podman -f -n '__fish_podman_no_subcommand' -a logs -d 'Fetch the logs of a container'
complete -c podman -A -n '__fish_seen_subcommand_from logs' -s f -l follow -f -d 'Follow log output.  The default is false'
complete -c podman -A -n '__fish_seen_subcommand_from logs' -s h -l help -f -d 'help for logs'
complete -c podman -A -n '__fish_seen_subcommand_from logs' -s l -l latest -f -d 'Act on the latest container podman is aware of'
complete -c podman -A -n '__fish_seen_subcommand_from logs' -l since -f -d 'Show logs since TIMESTAMP'
complete -c podman -A -n '__fish_seen_subcommand_from logs' -l tail -f -d 'Output the specified number of LINES at the end of the logs.  Defaults to 0, which prints all lines'
complete -c podman -A -n '__fish_seen_subcommand_from logs' -s t -l timestamps -f -d 'Output the timestamps in the log'

# mount
complete -c podman -f -n '__fish_podman_no_subcommand' -a mount -d "Mount a working container's root filesystem"
complete -c podman -A -n '__fish_seen_subcommand_from mount' -s a -l all -f -d 'Mount all containers'
complete -c podman -A -n '__fish_seen_subcommand_from mount' -l format -f -d 'Change the output format to Go template'
complete -c podman -A -n '__fish_seen_subcommand_from mount' -s h -l help -f -d 'help for mount'
complete -c podman -A -n '__fish_seen_subcommand_from mount' -s l -l latest -f -d 'Act on the latest container podman is aware of'
complete -c podman -A -n '__fish_seen_subcommand_from mount' -l notruncate -f -d 'Do not truncate output'

# pause
complete -c podman -f -n '__fish_podman_no_subcommand' -a pause -d 'Pause all the processes in one or more containers'
complete -c podman -A -n '__fish_seen_subcommand_from pause' -s a -l all -f -d 'Pause all running containers'
complete -c podman -A -n '__fish_seen_subcommand_from pause' -s h -l help -f -d 'help for pause'

# play
complete -c podman -f -n '__fish_podman_no_subcommand' -a play -d 'Play a pod'
complete -c podman -A -n '__fish_seen_subcommand_from play' -s h -l help -f -d 'help for play'

# pod
complete -c podman -f -n '__fish_podman_no_subcommand' -a pod -d 'Manage pods'
complete -c podman -A -n '__fish_seen_subcommand_from pod' -s h -l help -f -d 'help for pod'

# port
complete -c podman -f -n '__fish_podman_no_subcommand' -a port -d 'List port mappings or a specific mapping for the container'
complete -c podman -A -n '__fish_seen_subcommand_from port' -s a -l all -f -d 'Display port information for all containers'
complete -c podman -A -n '__fish_seen_subcommand_from port' -s h -l help -f -d 'help for port'
complete -c podman -A -n '__fish_seen_subcommand_from port' -s l -l latest -f -d 'Act on the latest container podman is aware of'

# ps
complete -c podman -f -n '__fish_podman_no_subcommand' -a ps -d 'List containers'
complete -c podman -A -n '__fish_seen_subcommand_from ps' -s a -l all -f -d 'Show all the containers, default is only running containers'
complete -c podman -A -n '__fish_seen_subcommand_from ps' -s f -l filter -f -d 'Filter output based on conditions given'
complete -c podman -A -n '__fish_seen_subcommand_from ps' -l format -f -d 'Pretty-print containers to JSON or using a Go template'
complete -c podman -A -n '__fish_seen_subcommand_from ps' -s h -l help -f -d 'help for ps'
complete -c podman -A -n '__fish_seen_subcommand_from ps' -s n -l last -f -d 'Print the n last created containers (all states) (default -1)'
complete -c podman -A -n '__fish_seen_subcommand_from ps' -s l -l latest -f -d 'Show the latest container created (all states)'
complete -c podman -A -n '__fish_seen_subcommand_from ps' -l no-trunc -f -d 'Display the extended information'
complete -c podman -A -n '__fish_seen_subcommand_from ps' -l ns -f -d 'Display namespace information'
complete -c podman -A -n '__fish_seen_subcommand_from ps' -s p -l pod -f -d 'Print the ID and name of the pod the containers are associated with'
complete -c podman -A -n '__fish_seen_subcommand_from ps' -s q -l quiet -f -d 'Print the numeric IDs of the containers only'
complete -c podman -A -n '__fish_seen_subcommand_from ps' -s s -l size -f -d 'Display the total file sizes'
complete -c podman -A -n '__fish_seen_subcommand_from ps' -l sort -f -d 'Sort output by command, created, id, image, names, runningfor, size, or status (default "created")'
complete -c podman -A -n '__fish_seen_subcommand_from ps' -l sync -f -d 'Sync container state with OCI runtime'
complete -c podman -A -n '__fish_seen_subcommand_from ps' -s w -l watch -f -d 'Watch the ps output on an interval in seconds'

# pull
complete -c podman -f -n '__fish_podman_no_subcommand' -a pull -d 'Pull an image from a registry'
complete -c podman -A -n '__fish_seen_subcommand_from pull' -l all-tags -f -d 'All tagged images inthe repository will be pulled'
complete -c podman -A -n '__fish_seen_subcommand_from pull' -l authfile -f -d 'Path of the authentication file. Default is ${XDG_RUNTIME_DIR}/containers/auth.json. Use REGISTRY_AUTH_FILE environment variable to override'
complete -c podman -A -n '__fish_seen_subcommand_from pull' -l cert-dir -f -d 'Pathname of a directory containing TLS certificates and keys'
complete -c podman -A -n '__fish_seen_subcommand_from pull' -l creds -f -d 'Credentials (USERNAME:PASSWORD) to use for authenticating to a registry'
complete -c podman -A -n '__fish_seen_subcommand_from pull' -s h -l help -f -d 'help for pull'
complete -c podman -A -n '__fish_seen_subcommand_from pull' -s q -l quiet -f -d 'Suppress output information when pulling images'
complete -c podman -A -n '__fish_seen_subcommand_from pull' -l signature-policy -f -d 'Pathname of signature policy file (not usually used)'
complete -c podman -A -n '__fish_seen_subcommand_from pull' -l tls-verify -f -d 'Require HTTPS and verify certificates when contacting registries (default true)'
complete -c podman -A -f -n '__fish_seen_subcommand_from pull' -a '(__fish_print_podman_images)' -d "Image"
complete -c podman -A -f -n '__fish_seen_subcommand_from pull' -a '(__fish_print_podman_repositories)' -d "Repository"

# push
complete -c podman -f -n '__fish_podman_no_subcommand' -a push -d 'Push an image to a specified destination'
complete -c podman -A -n '__fish_seen_subcommand_from push' -l authfile -f -d 'Path of the authentication file. Default is ${XDG_RUNTIME_DIR}/containers/auth.json. Use REGISTRY_AUTH_FILE environment variable to override'
complete -c podman -A -n '__fish_seen_subcommand_from push' -l cert-dir -f -d 'Pathname of a directory containing TLS certificates and keys'
complete -c podman -A -n '__fish_seen_subcommand_from push' -l compress -f -d "Compress tarball image layers when pushing to a directory using the 'dir' transport. (default is same compression type as source)"
complete -c podman -A -n '__fish_seen_subcommand_from push' -l creds -f -d 'Credentials (USERNAME:PASSWORD) to use for authenticating to a registry'
complete -c podman -A -n '__fish_seen_subcommand_from push' -s f -l format -f -d "Manifest type (oci, v2s1, or v2s2) to use when pushing an image using the 'dir:' transport (default is manifest type of source)"
complete -c podman -A -n '__fish_seen_subcommand_from push' -s h -l help -f -d 'help for push'
complete -c podman -A -n '__fish_seen_subcommand_from push' -s q -l quiet -f -d "Don't output progress information when pushing images"
complete -c podman -A -n '__fish_seen_subcommand_from push' -l remove-signatures -f -d 'Discard any pre-existing signatures in the image'
complete -c podman -A -n '__fish_seen_subcommand_from push' -l sign-by -f -d 'Add a signature at the destination using the specified key'
complete -c podman -A -n '__fish_seen_subcommand_from push' -l signature-policy -f -d 'Pathname of signature policy file (not usually used)'
complete -c podman -A -n '__fish_seen_subcommand_from push' -l tls-verify -f -d 'Require HTTPS and verify certificates when contacting registries (default true)'
complete -c podman -A -f -n '__fish_seen_subcommand_from push' -a '(__fish_print_podman_images)' -d "Image"
complete -c podman -A -f -n '__fish_seen_subcommand_from push' -a '(__fish_print_podman_repositories)' -d "Repository"

# restart
complete -c podman -f -n '__fish_podman_no_subcommand' -a restart -d 'Restart one or more containers'
complete -c podman -A -n '__fish_seen_subcommand_from restart' -s a -l all -f -d 'Restart all non-running containers'
complete -c podman -A -n '__fish_seen_subcommand_from restart' -s h -l help -f -d 'help for restart'
complete -c podman -A -n '__fish_seen_subcommand_from restart' -s l -l latest -f -d 'Act on the latest container podman is aware of'
complete -c podman -A -n '__fish_seen_subcommand_from restart' -l running -f -d 'Restart only running containers when --all is used'
complete -c podman -A -n '__fish_seen_subcommand_from restart' -l time -f -d 'Seconds to wait for stop before killing the container (default 10)'
complete -c podman -A -n '__fish_seen_subcommand_from restart' -s t -l timeout -f -d 'Seconds to wait for stop before killing the container (default 10)'

# rm
complete -c podman -f -n '__fish_podman_no_subcommand' -a rm -d 'Remove one or more containers'
complete -c podman -A -n '__fish_seen_subcommand_from rm' -s a -l all -f -d 'Remove all containers'
complete -c podman -A -n '__fish_seen_subcommand_from rm' -s f -l force -f -d 'Force removal of a running container.  The default is false'
complete -c podman -A -n '__fish_seen_subcommand_from rm' -s h -l help -f -d 'help for rm'
complete -c podman -A -n '__fish_seen_subcommand_from rm' -s l -l latest -f -d 'Act on the latest container podman is aware of'
complete -c podman -A -n '__fish_seen_subcommand_from rm' -s v -l volumes -f -d 'Remove the volumes associated with the container'

# rmi
complete -c podman -f -n '__fish_podman_no_subcommand' -a rmi -d 'Removes one or more images from local storage'
complete -c podman -A -n '__fish_seen_subcommand_from rmi' -s a -l all -f -d 'Remove all images'
complete -c podman -A -n '__fish_seen_subcommand_from rmi' -s f -l force -f -d 'Force Removal of the image'
complete -c podman -A -n '__fish_seen_subcommand_from rmi' -s h -l help -f -d 'help for rmi'

# run
complete -c podman -f -n '__fish_podman_no_subcommand' -a run -d 'Run a command in a new container'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l add-host -f -d 'Add a custom host-to-IP mapping (host:ip) (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l annotation -f -d 'Add annotations to container (key:value) (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from run' -s a -l attach -f -d 'Attach to STDIN, STDOUT or STDERR (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l blkio-weight -f -d 'Block IO weight (relative weight) accepts a weight value between 10 and 1000.'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l blkio-weight-device -f -d 'Block IO weight (relative device weight, format: DEVICE_NAME:WEIGHT)'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l cap-add -f -d 'Add capabilities to the container'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l cap-drop -f -d 'Drop capabilities from the container'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l cgroup-parent -f -d 'Optional parent cgroup for the container'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l cidfile -f -d 'Write the container ID to the file'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l conmon-pidfile -f -d 'Path to the file that will receive the PID of conmon'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l cpu-period -f -d 'Limit the CPU CFS (Completely Fair Scheduler) period'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l cpu-quota -f -d 'Limit the CPU CFS (Completely Fair Scheduler) quota'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l cpu-rt-period -f -d 'Limit the CPU real-time period in microseconds'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l cpu-rt-runtime -f -d 'Limit the CPU real-time runtime in microseconds'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l cpu-shares -f -d 'CPU shares (relative weight)'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l cpus -f -d 'Number of CPUs. The default is 0.000 which means no limit'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l cpuset-cpus -f -d 'CPUs in which to allow execution (0-3, 0,1)'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l cpuset-mems -f -d 'Memory nodes (MEMs) in which to allow execution (0-3, 0,1). Only effective on NUMA systems.'
complete -c podman -A -n '__fish_seen_subcommand_from run' -s d -l detach -f -d 'Run container in background and print container ID'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l detach-keys -f -d 'Override the key sequence for detaching a container. Format is a single character [a-Z] or `ctrl-<value>` where `<value>` is one of: `a-z`, `@`, `^`, `[`, `\\`, `]`, `^` or `_`'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l device -f -d 'Add a host device to the container (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l device-read-bps -f -d 'Limit read rate (bytes per second) from a device (e.g. --device-read-bps=/dev/sda:1mb)'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l device-read-iops -f -d 'Limit read rate (IO per second) from a device (e.g. --device-read-iops=/dev/sda:1000)'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l device-write-bps -f -d 'Limit write rate (bytes per second) to a device (e.g. --device-write-bps=/dev/sda:1mb)'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l device-write-iops -f -d 'Limit write rate (IO per second) to a device (e.g. --device-write-iops=/dev/sda:1000)'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l dns -f -d 'Set custom DNS servers'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l dns-opt -f -d 'Set custom DNS options'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l dns-search -f -d 'Set custom DNS search domains'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l entrypoint -f -d 'Overwrite the default ENTRYPOINT of the image'
complete -c podman -A -n '__fish_seen_subcommand_from run' -s e -l env -f -d 'Set environment variables in container'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l env-file -f -d 'Read in a file of environment variables'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l expose -f -d 'Expose a port or a range of ports (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l gidmap -f -d 'GID map to use for the user namespace'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l group-add -f -d 'Add additional groups to join (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l healthcheck-command -f -d "set a healthcheck command for the container ('none' disables the existing healthcheck)"
complete -c podman -A -n '__fish_seen_subcommand_from run' -l healthcheck-interval -f -d 'set an interval for the healthchecks (a value of disable results in no automatic timer setup) (default "30s")'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l healthcheck-retries -f -d 'the number of retries allowed before a healthcheck is considered to be unhealthy (default 3)'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l healthcheck-start-period -f -d 'the initialization time needed for a container to bootstrap (default "0s")'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l healthcheck-timeout -f -d 'the maximum time allowed to complete the healthcheck before an interval is considered failed (default "30s")'
complete -c podman -A -n '__fish_seen_subcommand_from run' -s h -l hostname -f -d 'Set container hostname'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l image-volume -f -d 'Tells podman how to handle the builtin image volumes. The options are: \'bind\', \'tmpfs\', or \'ignore\' (default "bind")'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l init -f -d 'Run an init binary inside the container that forwards signals and reaps processes'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l init-path -f -d 'Path to the container-init binary (default: "/usr/libexec/podman/catatonit")'
complete -c podman -A -n '__fish_seen_subcommand_from run' -s i -l interactive -f -d 'Keep STDIN open even if not attached'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l ip -f -d 'Specify a static IPv4 address for the container'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l ipc -f -d 'IPC namespace to use'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l kernel-memory -f -d 'Kernel memory limit (format: <number>[<unit>], where unit = b, k, m or g)'
complete -c podman -A -n '__fish_seen_subcommand_from run' -s l -l label -f -d 'Set metadata on container (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l label-file -f -d 'Read in a line delimited file of labels (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l log-driver -f -d 'Logging driver for the container'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l log-opt -f -d 'Logging driver options (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l mac-address -f -d 'Container MAC address (e.g. 92:d0:c6:0a:29:33), not currently supported'
complete -c podman -A -n '__fish_seen_subcommand_from run' -s m -l memory -f -d 'Memory limit (format: <number>[<unit>], where unit = b, k, m or g)'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l memory-reservation -f -d 'Memory soft limit (format: <number>[<unit>], where unit = b, k, m or g)'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l memory-swap -f -d "Swap limit equal to memory plus swap: '-1' to enable unlimited swap"
complete -c podman -A -n '__fish_seen_subcommand_from run' -l memory-swappiness -f -d 'Tune container memory swappiness (0 to 100, or -1 for system default) (default -1)'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l mount -f -d 'Attach a filesystem mount to the container (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l name -f -d 'Assign a name to the container'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l net -f -d 'Connect a container to a network (default "slirp4netns")'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l network -f -d 'Connect a container to a network (default "slirp4netns")'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l no-hosts -f -d 'Do not create /etc/hosts within the container, instead use the version from the image'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l oom-kill-disable -f -d 'Disable OOM Killer'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l oom-score-adj -f -d "Tune the host's OOM preferences (-1000 to 1000)"
complete -c podman -A -n '__fish_seen_subcommand_from run' -l pid -f -d 'PID namespace to use'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l pids-limit -f -d 'Tune container pids limit (set -1 for unlimited)'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l pod -f -d 'Run container in an existing pod'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l privileged -f -d 'Give extended privileges to container'
complete -c podman -A -n '__fish_seen_subcommand_from run' -s p -l publish -f -d "Publish a container's port, or a range of ports, to the host (default [])"
complete -c podman -A -n '__fish_seen_subcommand_from run' -s P -l publish-all -f -d 'Publish all exposed ports to random ports on the host interface'
complete -c podman -A -n '__fish_seen_subcommand_from run' -s q -l quiet -f -d 'Suppress output information when pulling images'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l read-only -f -d 'Make containers root filesystem read-only'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l restart -f -d 'Restart is not supported.  Please use a systemd unit file for restart'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l rm -f -d 'Remove container (and pod if created) after exit'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l rootfs -f -d 'The first argument is not an image but the rootfs to the exploded container'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l security-opt -f -d 'Security Options (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l shm-size -f -d 'Size of /dev/shm. The format is `<number><unit>` (default "65536k")'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l sig-proxy -f -d 'Proxy received signals to the process (default true)'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l stop-signal -f -d 'Signal to stop a container. Default is SIGTERM'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l stop-timeout -f -d 'Timeout (in seconds) to stop a container. Default is 10 (default 10)'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l subgidname -f -d 'Name of range listed in /etc/subgid for use in user namespace'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l subuidname -f -d 'Name of range listed in /etc/subuid for use in user namespace'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l sysctl -f -d 'Sysctl options (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l systemd -f -d 'Run container in systemd mode if the command executable is systemd or init (default true)'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l tmpfs -f -d 'Mount a temporary filesystem (tmpfs) into a container (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from run' -s t -l tty -f -d 'Allocate a pseudo-TTY for container'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l uidmap -f -d 'UID map to use for the user namespace'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l ulimit -f -d 'Ulimit options (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from run' -s u -l user -f -d 'Username or UID (format: <name|uid>[:<group|gid>])'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l userns -f -d 'User namespace to use'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l uts -f -d 'UTS namespace to use'
complete -c podman -A -n '__fish_seen_subcommand_from run' -s v -l volume -f -d 'Bind mount a volume into the container (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from run' -l volumes-from -f -d 'Mount volumes from the specified container(s) (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from run' -s w -l workdir -f -d 'Working directory inside the container'

# save
complete -c podman -f -n '__fish_podman_no_subcommand' -a save -d 'Save image to an archive'
complete -c podman -A -n '__fish_seen_subcommand_from save' -l compress -f -d "Compress tarball image layers when saving to a directory using the 'dir' transport. (default is same compression type as source)"
complete -c podman -A -n '__fish_seen_subcommand_from save' -l format -f -d 'Save image to oci-archive, oci-dir (directory with oci manifest type), docker-archive, docker-dir (directory with v2s2 manifest type) (default "docker-archive")'
complete -c podman -A -n '__fish_seen_subcommand_from save' -s h -l help -f -d 'help for save'
complete -c podman -A -n '__fish_seen_subcommand_from save' -s o -l output -f -d 'Write to a specified file (default: stdout, which must be redirected)'
complete -c podman -A -n '__fish_seen_subcommand_from save' -s q -l quiet -f -d 'Suppress the output'

# search
complete -c podman -f -n '__fish_podman_no_subcommand' -a search -d 'Search registry for image'
complete -c podman -A -n '__fish_seen_subcommand_from search' -l authfile -f -d 'Path of the authentication file. Default is ${XDG_RUNTIME_DIR}/containers/auth.json. Use REGISTRY_AUTH_FILE environment variable to override'
complete -c podman -A -n '__fish_seen_subcommand_from search' -s f -l filter -f -d 'Filter output based on conditions provided (default [])'
complete -c podman -A -n '__fish_seen_subcommand_from search' -l format -f -d 'Change the output format to a Go template'
complete -c podman -A -n '__fish_seen_subcommand_from search' -s h -l help -f -d 'help for search'
complete -c podman -A -n '__fish_seen_subcommand_from search' -l limit -f -d 'Limit the number of results'
complete -c podman -A -n '__fish_seen_subcommand_from search' -l no-trunc -f -d 'Do not truncate the output'
complete -c podman -A -n '__fish_seen_subcommand_from search' -l tls-verify -f -d 'Require HTTPS and verify certificates when contacting registries (default true)'

# start
complete -c podman -f -n '__fish_podman_no_subcommand' -a start -d 'Start one or more containers'
complete -c podman -A -n '__fish_seen_subcommand_from start' -s a -l attach -f -d "Attach container's STDOUT and STDERR"
complete -c podman -A -n '__fish_seen_subcommand_from start' -l detach-keys -f -d 'Override the key sequence for detaching a container. Format is a single character [a-Z] or ctrl-<value> where <value> is one of: a-z, @, ^, [, , or _'
complete -c podman -A -n '__fish_seen_subcommand_from start' -s h -l help -f -d 'help for start'
complete -c podman -A -n '__fish_seen_subcommand_from start' -s i -l interactive -f -d 'Keep STDIN open even if not attached'
complete -c podman -A -n '__fish_seen_subcommand_from start' -s l -l latest -f -d 'Act on the latest container podman is aware of'
complete -c podman -A -n '__fish_seen_subcommand_from start' -l sig-proxy -f -d 'Proxy received signals to the process (default true if attaching, false otherwise)'

# stats
complete -c podman -f -n '__fish_podman_no_subcommand' -a stats -d 'Display a live stream of container resource usage statistics'
complete -c podman -A -n '__fish_seen_subcommand_from stats' -s a -l all -f -d 'Show all containers. Only running containers are shown by default. The default is false'
complete -c podman -A -n '__fish_seen_subcommand_from stats' -l format -f -d 'Pretty-print container statistics to JSON or using a Go template'
complete -c podman -A -n '__fish_seen_subcommand_from stats' -s h -l help -f -d 'help for stats'
complete -c podman -A -n '__fish_seen_subcommand_from stats' -s l -l latest -f -d 'Act on the latest container podman is aware of'
complete -c podman -A -n '__fish_seen_subcommand_from stats' -l no-reset -f -d 'Disable resetting the screen between intervals'
complete -c podman -A -n '__fish_seen_subcommand_from stats' -l no-stream -f -d 'Disable streaming stats and only pull the first result, default setting is false'

# stop
complete -c podman -f -n '__fish_podman_no_subcommand' -a stop -d 'Stop one or more containers'
complete -c podman -A -n '__fish_seen_subcommand_from stop' -s a -l all -f -d 'Stop all running containers'
complete -c podman -A -n '__fish_seen_subcommand_from stop' -s h -l help -f -d 'help for stop'
complete -c podman -A -n '__fish_seen_subcommand_from stop' -s l -l latest -f -d 'Act on the latest container podman is aware of'
complete -c podman -A -n '__fish_seen_subcommand_from stop' -l time -f -d 'Seconds to wait for stop before killing the container (default 10)'
complete -c podman -A -n '__fish_seen_subcommand_from stop' -s t -l timeout -f -d 'Seconds to wait for stop before killing the container (default 10)'

# system
complete -c podman -f -n '__fish_podman_no_subcommand' -a system -d 'Manage podman'
complete -c podman -A -n '__fish_seen_subcommand_from system' -s h -l help -f -d 'help for system'

# tag
complete -c podman -f -n '__fish_podman_no_subcommand' -a tag -d 'Add an additional name to a local image'
complete -c podman -A -n '__fish_seen_subcommand_from tag' -s h -l help -f -d 'help for tag'

# top
complete -c podman -f -n '__fish_podman_no_subcommand' -a top -d 'Display the running processes of a container'
complete -c podman -A -n '__fish_seen_subcommand_from top' -s h -l help -f -d 'help for top'
complete -c podman -A -n '__fish_seen_subcommand_from top' -s l -l latest -f -d 'Act on the latest container podman is aware of'

# umount
complete -c podman -f -n '__fish_podman_no_subcommand' -a umount -d "Unmounts working container's root filesystem"
complete -c podman -A -n '__fish_seen_subcommand_from umount' -s a -l all -f -d 'Umount all of the currently mounted containers'
complete -c podman -A -n '__fish_seen_subcommand_from umount' -s f -l force -f -d 'Force the complete umount all of the currently mounted containers'
complete -c podman -A -n '__fish_seen_subcommand_from umount' -s h -l help -f -d 'help for umount'
complete -c podman -A -n '__fish_seen_subcommand_from umount' -s l -l latest -f -d 'Act on the latest container podman is aware of'

# unpause
complete -c podman -f -n '__fish_podman_no_subcommand' -a unpause -d 'Unpause the processes in one or more containers'
complete -c podman -A -n '__fish_seen_subcommand_from unpause' -s a -l all -f -d 'Unpause all paused containers'
complete -c podman -A -n '__fish_seen_subcommand_from unpause' -s h -l help -f -d 'help for unpause'

# varlink
complete -c podman -f -n '__fish_podman_no_subcommand' -a varlink -d 'Run varlink interface'
complete -c podman -A -n '__fish_seen_subcommand_from varlink' -s h -l help -f -d 'help for varlink'
complete -c podman -A -n '__fish_seen_subcommand_from varlink' -s t -l timeout -f -d 'Time until the varlink session expires in milliseconds.  Use 0 to disable the timeout (default 1000)'

# version
complete -c podman -f -n '__fish_podman_no_subcommand' -a version -d 'Display the Podman Version Information'
complete -c podman -A -n '__fish_seen_subcommand_from version' -s f -l format -f -d 'Change the output format to JSON or a Go template'
complete -c podman -A -n '__fish_seen_subcommand_from version' -s h -l help -f -d 'help for version'

# volume
complete -c podman -f -n '__fish_podman_no_subcommand' -a volume -d 'Manage volumes'
complete -c podman -A -n '__fish_seen_subcommand_from volume' -s h -l help -f -d 'help for volume'

# wait
complete -c podman -f -n '__fish_podman_no_subcommand' -a wait -d 'Block on one or more containers'
complete -c podman -A -n '__fish_seen_subcommand_from wait' -s h -l help -f -d 'help for wait'
complete -c podman -A -n '__fish_seen_subcommand_from wait' -s i -l interval -f -d 'Milliseconds to wait before polling for completion (default 250)'
complete -c podman -A -n '__fish_seen_subcommand_from wait' -s l -l latest -f -d 'Act on the latest container podman is aware of'


