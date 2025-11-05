{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  dbus,
  udev,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "intiface-engine";
  version = "3.0.8";

  src = fetchFromGitHub {
    owner = "intiface";
    repo = "intiface-engine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6gtCucWVSCDn5QaNI7E5m15TAjz3ngqiUiJy2qY/d+A=";
  };

  cargoHash = "sha256-MJARQnGbRsjntiBW+3Mhh5TQVAs3tADlUBUb1/UTtec=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    udev
  ];

  meta = {
    description = "CLI frontend for Intiface";
    homepage = "https://github.com/intiface/intiface-engine";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
