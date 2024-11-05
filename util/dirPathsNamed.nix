dir:
let
  filenames = builtins.attrNames (builtins.readDir dir);
  pathsNamedList = map
    (filename: {
      name = builtins.replaceStrings [".nix"] [""] filename;
      value = /${dir}/${filename};
    })
    filenames;
  pathsNamed = builtins.listToAttrs pathsNamedList;
in
pathsNamed
