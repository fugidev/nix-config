{
  lib,
  stdenv,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  fetchurl,
  chromium,
  jellyfinUrl ? throw "need to supply jellyfinUrl via callPackage or override",
}:
stdenv.mkDerivation (finalAttrs: {
  name = "jellyfin-chromium";

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/jellyfin/jellyfin-media-player/5ded0bccb38c06d6249bac91d095f358c5824601/resources/images/icon.svg";
    hash = "sha256-tnRNXJ8t8tq7P/jwEmC42/y24OIszM0mqTat72ETLf8=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  phases = [ "installPhase" ];

  installPhase = ''
    runHook preInstall

    makeWrapper ${lib.getExe chromium} $out/bin/jellyfin-chromium \
      --add-flags "--enable-features=AcceleratedVideoDecodeLinuxGL" \
      --add-flags "--new-window" \
      --add-flags "--app='${jellyfinUrl}'"

    install -Dm644 "${finalAttrs.icon}" "$out/share/icons/hicolor/scalable/apps/com.github.iwalton3.jellyfin-media-player.svg"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "jellyfin-chromium";
      desktopName = "Jellyfin";
      exec = "jellyfin-chromium";
      icon = "com.github.iwalton3.jellyfin-media-player";
      categories = [
        "AudioVideo"
        "Video"
        "Player"
        "TV"
      ];
    })
  ];

  meta.mainProgram = "jellyfin-chromium";
})
