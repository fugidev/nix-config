{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "AriaNg";
  version = "1.3.2";

  src = fetchzip {
    url = "https://github.com/mayswind/AriaNg/releases/download/${version}/AriaNg-${version}.zip";
    sha256 = "sha256-jWSw8c+OpalB5Za5KE2eLfejYWz1GRMEVv/Zx9wJdvk=";
    stripRoot = false;
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cp -R . $out

    runHook postInstall
  '';
}
