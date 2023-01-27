{ lib
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "apple_cursor";
  version = "2.0.0";

  src = builtins.fetchTarball {
    url = "https://github.com/ful1e5/apple_cursor/releases/download/v${version}/macOS-Monterey.tar.gz";
    sha256 = "1cvkrxfakcbrj7wkjr22j3ricc6p0vvvv727irdm6hvsrrk9ly9h";
  };

  dontBuild = true;

  installPhase = ''
    install -d "$out/share/icons"
    cp -r . "$out/share/icons/macOS-Monterey"
  '';
}
