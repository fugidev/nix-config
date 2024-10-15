lib:
let
  filenames = builtins.filter (x: x != "default.nix") (builtins.attrNames (builtins.readDir ./.));
  filenameToAttr = n: lib.nameValuePair (lib.removeSuffix ".nix" n) (import ./${n});
  attrs = lib.listToAttrs (map filenameToAttr filenames);
in
attrs
