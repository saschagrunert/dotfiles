#!/usr/bin/env fish
if test -n /nix; and test -n "$HOME" ; and test -n "$USER" ;
    for d in $PATH; if test -e $d; set __savedpath $__savedpath $d; end; end;
    set -xg PATH /nix/store/dm20hrdk6s4jzfmk1197p2nya0p8fy3a-coreutils-8.29/bin

    # Set up the per-user profile.
    # This part should be kept in sync with nixpkgs:nixos/modules/programs/shell.nix
    set -g  NIX_LINK $HOME/.nix-profile
    set -g  NIX_USER_PROFILE_DIR /nix/var/nix/profiles/per-user/$USER

    mkdir -m 0755 -p "$NIX_USER_PROFILE_DIR"

    if test (stat --printf '%u' "$NIX_USER_PROFILE_DIR") != (id -u) ;
        echo "Nix: WARNING: bad ownership on "$NIX_USER_PROFILE_DIR", should be "(id -u) >&2
    end

    if test -w "$HOME" ;
        test -L "$NIX_LINK" ;
        if test ! $status -eq 0;
            echo "Nix: creating $NIX_LINK" >&2
            if test "$USER" != root ;
                ln -s "$NIX_USER_PROFILE_DIR"/profile "$NIX_LINK";
                if test ! $status -eq 0;
                    echo "Nix: WARNING: could not create $NIX_LINK -> $NIX_USER_PROFILE_DIR/profile" >&2
                end
            else
                # Root installs in the system-wide profile by default.
                ln -s /nix/var/nix/profiles/default "$NIX_LINK"
            end
        end

        # Subscribe the user to the unstable Nixpkgs channel by default.
        if test ! -e "$HOME/.nix-channels" ;
            echo "https://nixos.org/channels/nixpkgs-unstable nixpkgs" > "$HOME/.nix-channels"
        end

        # Create the per-user garbage collector roots directory.
        set -g  __user_gcroots /nix/var/nix/gcroots/per-user/"$USER"
        mkdir -m 0755 -p "$__user_gcroots"
        if test (stat --printf '%u' "$__user_gcroots") != (id -u) ;
            echo "Nix: WARNING: bad ownership on $__user_gcroots, should be "(id -u) >&2
        end
        set -e __user_gcroots

        # Set up a default Nix expression from which to install stuff.
        set -g  __nix_defexpr "$HOME"/.nix-defexpr
        test -L "$__nix_defexpr" ; and rm -f "$__nix_defexpr"
        mkdir -m 0755 -p "$__nix_defexpr"
        set -e __nix_defexpr
    end

    # Append ~/.nix-defexpr/channels/nixpkgs to $NIX_PATH so that
    # <nixpkgs> paths work when the user has fetched the Nixpkgs
    # channel.
    if test -z "$NIX_PATH";
         set -xg NIX_PATH nixpkgs=$HOME/.nix-defexpr/channels/nixpkgs
    else
         set -xg NIX_PATH $NIX_PATH nixpkgs=$HOME/.nix-defexpr/channels/nixpkgs
    end

    # Set up environment.
    # This part should be kept in sync with nixpkgs:nixos/modules/programs/environment.nix
    set -g  NIX_PROFILES /nix/var/nix/profiles/default $NIX_USER_PROFILE_DIR
    set -xg NIX_SSL_CERT_FILE /etc/ssl/ca-bundle.pem

    if test -n "$MANPATH" ;
        set -xg MANPATH $NIX_LINK/share/man $MANPATH
    end

    set -xg PATH $NIX_LINK/bin $__savedpath
    set -e __savedpath; set -e NIX_LINK; set -e NIX_USER_PROFILE_DIR; set -e NIX_PROFILES
end
