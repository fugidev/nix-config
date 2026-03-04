{
  stdenv,
  fetchFromGitHub,
  libusb1,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "imx_usb_loader";

  src = fetchFromGitHub {
    owner = "boundarydevices";
    repo = "imx_usb_loader";
    rev = "30b43d69770cd69e84c045dc9dcabb1f3e9d975a";
    hash = "sha256-jHNnIoAek3MlYPDgBMQzyP+XZtLSitER9UwrPMxbvck=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libusb1
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -m755 imx_usb imx_uart $out/bin/
  '';
})
