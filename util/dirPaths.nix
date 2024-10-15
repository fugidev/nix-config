dir:
let
  filenames = builtins.attrNames (builtins.readDir dir);
  paths = map (filename: /${dir}/${filename}) filenames;
in
paths
