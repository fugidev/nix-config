{ config, lib, pkgs, osConfig, ... }:
let
  mkPrefs = fn: lib.concatLines (
    lib.mapAttrsToList
      (name: value: "${fn}(\"${name}\", ${builtins.toJSON value});")
      config.programs.librewolf.settings
  );

  nixos-unstable-small-src = pkgs.fetchzip {
    url = "https://github.com/NixOS/nixpkgs/archive/6c16b7ce10e5ef1fee3aecfb327be61888818a7a.tar.gz";
    hash = "sha256-udCSZoKawLiNJKFQgikkN96tvVJggs61ihRq8sRt8tM=";
  };

  nixos-unstable-small = import nixos-unstable-small-src {
    inherit (osConfig.nixpkgs) config;
    crossSystem = osConfig.nixpkgs.crossSystem or null;
    localSystem = osConfig.nixpkgs.localSystem.system or osConfig.nixpkgs.system;
  };
in
{
  programs.librewolf = {
    enable = true;
    package = nixos-unstable-small.librewolf;
    settings = {
      # make it usable
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.downloads" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "privacy.clearOnShutdown.cache" = false;
      "privacy.clearOnShutdown_v2.cache" = false;
      "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
      # sync
      "identity.fxaccounts.enabled" = true;
      "services.sync.engine.addons" = true;
      "services.sync.engine.addresses" = false;
      "services.sync.engine.creditcards" = false;
      "services.sync.engine.history" = false;
      "services.sync.engine.passwords" = false;
      # "services.sync.engine.prefs" = false;
      # "services.sync.engine.prefs.modified" = false;
      "services.sync.engine.tabs" = false;
      # prefetching (also needs to be disabled in uBO)
      "network.dns.disablePrefetch" = false;
      "network.http.speculative-parallel-limit" = 20;
      "network.predictor.enabled" = true;
      "network.prefetch-next" = true;
      "browser.places.speculativeConnect.enabled" = true;
      "browser.urlbar.speculativeConnect.enabled" = true;
      # other settings
      "browser.fullscreen.autohide" = false;
      "browser.compactmode.show" = true;
      "browser.uidensity" = 1;
      "browser.startup.page" = 3; # restore previous session
      "browser.download.useDownloadDir" = true;
      "browser.translations.neverTranslateLanguages" = "de";
      "privacy.donottrackheader.enabled" = true;
      "middlemouse.paste" = false;
      "clipboard.autocopy" = false;
      "general.autoScroll" = true;
    };
  };

  home.file.".librewolf/librewolf.overrides.cfg".text = lib.mkAfter ''
    ${mkPrefs "prefs"}
    ${mkPrefs "lockPrefs"}
  '';
}
