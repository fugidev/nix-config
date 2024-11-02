{ config, util, ... }:
{
  imports = (util.dirPaths ./modules) ++ [ ./hardware-configuration.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # user configuration
  users.users.root.openssh.authorizedKeys.keys = config.fugi.authorizedKeys;

  system.stateVersion = "24.05";
}
