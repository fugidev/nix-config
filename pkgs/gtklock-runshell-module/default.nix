{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  gtk3,
  gtklock,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtklock-runshell-module";
  version = "4.0.0";

  src = fetchFromGitLab {
    owner = "wef";
    repo = "gtklock-runshell-module";
    rev = finalAttrs.version;
    hash = "sha256-aVB8e+kk/jNxIJsHdeNxvNqqrV9ThcO9nHtj/gJ6/is=";
  };

  patches = [ ./dont-hide.patch ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gtk3
  ];

  passthru.tests.testModule = gtklock.testModule finalAttrs.finalPackage;

  meta = {
    description = "Gtklock module to add output from a script to the lockscreen";
    homepage = "https://gitlab.com/wef/gtklock-runshell-module";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fugi ];
    platforms = lib.platforms.linux;
  };
})
