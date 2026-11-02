function up -d "Update system"
    nix flake update --flake $DOTFILES
    and sudo nixos-rebuild switch --flake $DOTFILES#nixos
    # Record the lock only once it built, and only on main so a feature
    # branch does not pick up the update. Other staged changes stay out.
    and if test (git -C $DOTFILES branch --show-current) = main
        and not git -C $DOTFILES diff --quiet -- flake.lock
        git -C $DOTFILES commit -s -m "Update nixpkgs" -- flake.lock
        and git -C $DOTFILES push
    end
    and sudo nix-collect-garbage -d
    and rustup update
    # The waybar indicator caches its result for hours, so refresh it here
    # instead of leaving the bar stale until its next interval.
    # Without a running waybar, for example over SSH, there is nothing to do.
    and begin
        pkill -RTMIN+9 waybar; or true
    end
end
