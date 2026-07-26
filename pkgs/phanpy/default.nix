# based on:
# https://github.com/msfjarvis/dotfiles/blob/4a3587b612fae214b90b822383750331ff358934/packages/phanpy/default.nix
# https://github.com/NixOS/nixpkgs/pull/436823
{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  nodejs_22,
  env ? { },
}:

buildNpmPackage (finalAttrs: {
  pname = "phanpy";
  version = "2026.06.23.05dcc55";

  src = fetchFromGitHub {
    owner = "cheeaun";
    repo = "phanpy";
    tag = "${finalAttrs.version}";
    hash = "sha256-kqzlHHTjuDzQFaLO499y/w+6KJb8TCS4HSgAY2sc2xw=";
  };

  env = rec {
    PHANPY_COMMIT_HASH = builtins.substring 11 18 finalAttrs.version;
    PHANPY_COMMIT_TIME = builtins.substring 0 10 finalAttrs.version;
    PHANPY_BUILD_TIME = PHANPY_COMMIT_TIME;
  }
  // env;

  nodejs = nodejs_22;

  npmDepsHash = "sha256-zwl7qCo/Nhu2dMgwFP0YFD7MZmtyKIYNsIXCTNcyWAU=";

  npmRebuildFlags = [ "--ignore-scripts" ];

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/cheeaun/phanpy/pull/1543.diff";
      hash = "sha256-IDzi/FhoAfePPnXHVVQUF9mhcNafrzfw9eudBAUJYXM=";
    })
    ./welcome-page.patch
    ./catchup-range.patch
    ./catchup-filters.patch
    # ./reenable-console.patch
  ];

  preBuild = ''
    # this breaks the build when not running in a terminal
    substituteInPlace node_modules/@lingui/cli/dist/lingui-extract.js \
      --replace-fail "spinner.start();" ""

    npm run generate-icons
    npm run messages:extract -- --verbose
  '';

  installPhase = ''
    runHook preInstall

    cp -ar dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A minimalistic opinionated Mastodon web client";
    homepage = "https://phanpy.social/";
    license = lib.licenses.mit;
  };
})
