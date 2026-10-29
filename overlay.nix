_: prev:
let
  dirPathsNamed = import ./util/dirPathsNamed.nix;
  pkgs = builtins.mapAttrs (name: path: prev.callPackage path { }) (dirPathsNamed ./pkgs);
in
pkgs
