# nix run nixpkgs\#nix-update -- --flake --version=branch owncast-unstable

{
  owncast,
  fetchFromGitHub,
  nix-update-script,
}:

owncast.overrideAttrs (old: {
  version = "0.3.0-unstable-2026-10-13";

  src = fetchFromGitHub {
    owner = "owncast";
    repo = "owncast";
    rev = "85791798c2f70564255edb22be8dc552f4fb158e";
    hash = "sha256-8NZzfbdNOxrF+uWWonM0gpVdhyidx084g0tia11HP60=";
  };

  vendorHash = "sha256-WUjsBNcL+AD+lHmPLRZWvlGBRvQ7YuuTOVloislp5/M=";

  passthru = old.passthru // {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
  };
})
