{ stdenv, lib, kernel }:

stdenv.mkDerivation {
  pname = "usbip-host-patched";
  inherit (kernel) version;

  inherit (kernel) src;

  patches = [
    ../patches/0001-usbip-drain-pending-PDU-payload-on-invalid-endpoint.patch
    ../patches/0002-usbip-block-SET_INTERFACE-for-isoc-alt-settings.patch
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      M=$(pwd)/drivers/usb/usbip \
      modules
  '';

  installPhase = ''
    install -D -t $out/lib/modules/${kernel.modDirVersion}/extra \
      drivers/usb/usbip/usbip-host.ko
  '';

  meta = {
    description = "Patched usbip-host: drain socket on invalid endpoint, block isoc alt settings";
    license = lib.licenses.gpl2Plus;
  };
}
