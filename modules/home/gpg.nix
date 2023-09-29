{ config, lib, pkgs, ... }:
{
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    pinentryFlavor = "qt";
  };
}
