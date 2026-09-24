{ inputs, ... }:
let
  package = inputs.noctalia.packages."aarch64-linux".default;
in
{
  programs.noctalia-shell = {
    package = package.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        ./bar-size.patch
        ./bar-center-notch.patch
      ];
    });
  };
}
