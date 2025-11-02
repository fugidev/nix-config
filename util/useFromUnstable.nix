{ modules ? [ ], pkgs ? [ ], src ? null }:
{ config, lib, inputs, ... }:
let
  srcOrDefault = if src != null then src else inputs.nixpkgs-unstable;
  srcPkgs = import srcOrDefault {
    inherit (config.nixpkgs) config;
    crossSystem = config.nixpkgs.crossSystem or null;
    localSystem = config.nixpkgs.localSystem.system or config.nixpkgs.system;
  };
in
{
  disabledModules = modules;

  imports = builtins.map (module: "${srcOrDefault}/nixos/modules/${module}") modules;

  config.nixpkgs.overlays = [
    (self: super:
      lib.genAttrs pkgs
      (pkg: srcPkgs.${pkg})
    )
  ];
}
