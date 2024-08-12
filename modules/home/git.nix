{ lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Fugi";
    userEmail = "me@fugi.dev";

    signing = {
      key = "BF37903AE6FD294C4C674EE24472A20091BFA792";
      signByDefault = true;
    };

    extraConfig = {
      core.pager = "diffr | less";
      interactive.diffFilter = "diffr";
      init.defaultBranch = "main";
    };
  };

  home.packages = [
    (pkgs.writeShellScriptBin "diffr" ''
      # added color is background*10/green
      # removed color is background*5/red
      exec ${lib.getExe pkgs.diffr} \
        --colors refine-added:none:background:26,35,26:foreground:green \
        --colors refine-removed:none:background:53,27,24:foreground:red \
        "$@"
    '')
  ];
}
