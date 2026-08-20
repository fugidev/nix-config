{
  lib,
  stdenvNoCC,
  makeWrapper,
  fetchFromGitHub,
  chromaprint,
  ffmpeg,
  python3,
  pnpm_10,
  pnpmConfigHook,
  fetchPnpmDeps,
  nodejs,
}:
let
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "HabiRabbu";
    repo = "DroppedNeedle";
    tag = "v${version}";
    hash = "sha256-Naj9ET9ui2qlv8cShIn1Zgm5GZyguOm4KVVFVwhNHeA=";
  };

  frontend = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "droppedneedle-frontend";
    inherit version src;

    sourceRoot = "${finalAttrs.src.name}/frontend";

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_10
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/frontend";
      pnpm = pnpm_10;
      fetcherVersion = 3;
      hash = "sha256-0Os0oXP9aFi/STih2IDXKOThqEPdKlvdEshYZmbP0ps=";
    };

    buildPhase = ''
      runHook preBuild

      pnpm run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r ./build/* $out/

      runHook postInstall
    '';
  });

  python = python3.withPackages (
    ps:
    with ps;
    [
      aiofiles
      bcrypt
      cryptography
      fastapi
      h2
      httpx
      msgspec
      mutagen
      packaging
      pydantic
      pydantic-core
      pydantic-settings
      python-dotenv
      python-multipart
      rapidfuzz
      starlette
      unidecode
      uvicorn
    ]
    ++ httpx.optional-dependencies.http2
    ++ uvicorn.optional-dependencies.standard
  );

in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "droppedneedle";
  inherit version src;

  strictDeps = true;
  __structuredAttrs = true;

  passthru = {
    inherit frontend;
  };

  patches = [
    # ./logs.patch
    ./ignore_nzb_password.patch
    # ./logs-fingerprinter.patch
    ./source_priority.patch
    ./album_manual_pick.patch
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/droppedneedle
    cp -r ./backend/* $out/lib/droppedneedle/

    ln -s ${frontend} $out/lib/droppedneedle/static

    mkdir -p $out/bin

    makeWrapper ${lib.getExe' python "uvicorn"} $out/bin/droppedneedle \
      --prefix PYTHONPATH : "$out/lib/droppedneedle" \
      --prefix PATH : ${ffmpeg}/bin \
      --prefix PATH : ${chromaprint}/bin \
      --set COMMIT_TAG ${finalAttrs.src.tag or "dev"} \
      --add-flags "main:app"

    runHook postInstall
  '';

  meta.mainProgram = "droppedneedle";
})
