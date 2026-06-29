{ stdenv, lib, kernel }:

stdenv.mkDerivation {
  pname = "usbip-host-patched";
  version = kernel.version;

  src = kernel.src;

  patches = [
    ../patches/usbip-fix-stream-desync-on-invalid-endpoint.patch
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
