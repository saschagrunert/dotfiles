function up -d "Update system"
    nix flake update --flake $DOTFILES
    and sudo nix-collect-garbage -d
    and sudo nixos-rebuild switch --flake $DOTFILES#nixos
    and sudo nix-collect-garbage -d
    and rustup update
end
