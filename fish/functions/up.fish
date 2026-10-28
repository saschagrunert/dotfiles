function up -d "Update system"
    nix flake update --flake $DOTFILES
    and sudo nixos-rebuild switch --flake $DOTFILES#nixos
    and sudo nix-collect-garbage -d
    and rustup update
    # The waybar indicator caches its result for hours, so refresh it here
    # instead of leaving the bar stale until its next interval.
    # Without a running waybar there is nothing to do.
    and begin
        $DOTFILES/waybar/signal 9 2>/dev/null; or true
    end
end
