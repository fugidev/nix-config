{ modules ? [ ], pkgs ? [ ], src ? null }:
{ config, lib, inputs, ... }:
let
  hostSystem = config.nixpkgs.system;
  srcOrDefault = if src != null then src else inputs.nixpkgs;
in
{
  disabledModules = modules;

  imports = builtins.map (module: "${srcOrDefault}/nixos/modules/${module}") modules;

  config.nixpkgs.overlays = [
    (self: super:
      lib.genAttrs pkgs
      (pkg: srcOrDefault.legacyPackages.${hostSystem}.${pkg})
    )
  ];
}
