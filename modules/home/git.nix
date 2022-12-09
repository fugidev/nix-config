{ config, pkgs, lib, ... }: {
  programs.git = {
    enable = true;
    userName = "Fugi";
    userEmail = "me@fugi.dev";

    signing = {
      key = "BF37903AE6FD294C4C674EE24472A20091BFA792";
      signByDefault = true;
    };

    extraConfig = {
      core = {
        pager = "less -+\$LESS -RS";
      };
    };
  };
}
