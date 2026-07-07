{ pkgs ? import <nixpkgs> { } }:

let
  appimage-run-shadow = pkgs.appimage-run.override {
    extraPkgs = p: [
      p.libva
      p.libinput
      p.libxau
      p.libxdmcp
    ];
  };

  usbip = "${pkgs.linuxPackages.usbip}/bin/usbip";
  usbipd = "${pkgs.linuxPackages.usbip}/bin/usbipd";
in
pkgs.mkShell {
  packages = [ appimage-run-shadow ];

  shellHook = ''
    # Prevent Shadow from forwarding the yoke as native gamepads
    export SDL_GAMECONTROLLER_IGNORE_DEVICES=0x10F5/0x7001

    # Start Tailscale for USB/IP connectivity to Shadow
    sudo systemctl start tailscaled
    sudo tailscale up

    # Export Turtle Beach devices via USB/IP (auto-detect busids)
    sudo modprobe usbip-host
    USBIP_BUSIDS=""
    for d in /sys/bus/usb/devices/*; do
      vid=$(cat "$d/idVendor" 2>/dev/null)
      if [ "$vid" = "10f5" ]; then
        busid=$(basename "$d")
        sudo ${usbip} bind -b "$busid" 2>/dev/null
        USBIP_BUSIDS="$USBIP_BUSIDS $busid"
      fi
    done
    sudo ${usbipd} -D

    appimage-run /home/sascha/games/shadow/ShadowPC.AppImage

    # Cleanup USB/IP
    for busid in $USBIP_BUSIDS; do
      sudo ${usbip} unbind -b "$busid" 2>/dev/null
    done
    sudo killall usbipd 2>/dev/null
    sudo tailscale down
    sudo systemctl stop tailscaled
    exit
  '';
}
