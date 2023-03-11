{ config, lib, pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${pkgs.sway}/bin/sway";
        user = "fugi";
      };
      default_session = {
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd $SHELL";
      };
    };
  };
}
