function up -d "Update system"
    nix flake update --flake $DOTFILES
    and sudo nixos-rebuild switch --flake $DOTFILES#nixos
    and rustup update
    and sudo nix-collect-garbage --delete-older-than 7d
end
