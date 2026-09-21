# /boot is a 196M ESP with room for a single kernel, so the kernel of the
# running system has to make way before nixos-rebuild copies the new one in.
# Nothing is removed while the kernel stays the same. When it changes, /boot
# holds no bootable kernel until the rebuild installs the new one, which it does
# before it activates anything.
function _prune-boot -a system -d "Remove kernels /boot does not need for the given system"
    # Files are named after their store path, with the slashes turned into
    # dashes, the same way the GRUB installer names them.
    set -l keep (basename $system)-secrets
    for f in kernel initrd
        set -l path (realpath -e $system/$f 2>/dev/null)
        # Without both names every kernel would look obsolete below.
        if test -z "$path"
            echo "up: $system/$f does not resolve, leaving /boot alone" >&2
            return 1
        end
        set -a keep (string replace -r '^/nix/store/' '' $path | string replace -a / -)
    end
    for f in (find /boot/kernels -maxdepth 1 -type f 2>/dev/null)
        if not contains (basename $f) $keep
            echo "Removing $f, /boot has no room for two kernels"
            sudo rm -f -- $f
            or return 1
        end
    end
end

function up -d "Update system"
    nix flake update --flake $DOTFILES
    and sudo nix-collect-garbage -d
    and set -l system (nix build --no-link --print-out-paths \
        $DOTFILES#nixosConfigurations.nixos.config.system.build.toplevel)
    and test -n "$system"
    and _prune-boot $system
    and sudo nixos-rebuild switch --flake $DOTFILES#nixos
    and sudo nix-collect-garbage -d
    and rustup update
    # The waybar indicator caches its result for hours, so refresh it here
    # instead of leaving the bar stale until its next interval.
    and pkill -RTMIN+9 waybar
end
