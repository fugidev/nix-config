{ lib
, stdenv
, fetchurl
, rpmextract
}:

stdenv.mkDerivation rec {
  # adapted from https://aur.archlinux.org/packages/ttf-twemoji
  pname = "ttf-twemoji";
  version = "14.0.2";
  _fedrel = "2.fc37";

  src = fetchurl {
    url = "https://kojipkgs.fedoraproject.org/packages/twitter-twemoji-fonts/${version}/${_fedrel}/noarch/twitter-twemoji-fonts-${version}-${_fedrel}.noarch.rpm";
    sha256 = "sha256-GK7JZzHs/9gSViSTPPv3V/LFfdGzj4F50VO5HSqs0VE=";
  };

  dontBuild = true;

  nativeBuildInputs = [ rpmextract ];

  unpackPhase = ''
    ${rpmextract}/bin/rpmextract $src
  '';

  installPhase = ''
    install -Dm755 usr/share/fonts/twemoji/Twemoji.ttf $out/share/fonts/truetype/Twemoji.ttf
  '';
}
