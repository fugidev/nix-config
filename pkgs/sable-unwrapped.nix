{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs-slim_24,
  nix-update-script,
}:

let
  nodejs-slim = nodejs-slim_24;
  pnpm = pnpm_10.override { inherit nodejs-slim; };
in

stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "sable-unwrapped";
  version = "1.18.3";

  src = fetchFromGitHub {
    owner = "SableClient";
    repo = "Sable";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yi70WBH0lDw1h4Oy6NNfi71kp32be3rtZDt3/C2e524=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-y5Gv/IQ5qkxhj8QHtv7p16bj/f3eHWXGoeZ4CPwkxhY=";
  };

  nativeBuildInputs = [
    nodejs-slim
    pnpmConfigHook
    pnpm
  ];

  # Controls how the application displays its version, e.g. "v1.14.0 (nix)".
  # Also prevents some attempts to execute git during build.
  env = {
    VITE_IS_RELEASE_TAG = "true";
    VITE_BUILD_HASH = "nix";
  };

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An almost stable Matrix client";
    homepage = "https://github.com/SableClient/Sable";
    changelog = "https://github.com/SableClient/Sable/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      fugi
    ];
  };
})
