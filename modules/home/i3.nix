{ config, pkgs, lib, ... }:
let
  mod = "Mod4";
in
{
  xsession.enable = true;
  xsession.windowManager.i3 = {
    enable = true;

    config = {
      modifier = mod;

      defaultWorkspace = "workspace number 1";

      bars = [{
        position = "top";
      }];
    };
  };
}
