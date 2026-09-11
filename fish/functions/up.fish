function up -d "Update system"
    nix flake update --flake $DOTFILES
    and sudo nix-collect-garbage -d
    and sudo /nix/var/nix/profiles/system/bin/switch-to-configuration boot
    and sudo nixos-rebuild switch --flake $DOTFILES#nixos
    and sudo nix-collect-garbage -d
    and rustup update
end
