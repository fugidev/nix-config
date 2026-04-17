{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs_24,
}:

let
  nodejs = nodejs_24;
  pnpm = pnpm_10.override { inherit nodejs; };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "sable-unwrapped";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "SableClient";
    repo = "Sable";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zoGKs0pm9m42JrTNAdU33LP139JlVz3RZnkTyY0aiqY=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-2GwUz0jsuVKQZyeidM0F4rDzijm9AFcAxN7x/m/b3Is=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

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

  meta = {
    description = "An almost stable Matrix client";
    homepage = "https://github.com/SableClient/Sable/";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      fugi
    ];
  };
})
