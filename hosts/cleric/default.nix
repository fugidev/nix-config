{ config, pkgs, ... }:
let
  hostModulesFilenames = builtins.attrNames (builtins.readDir ./modules);
  hostModules = map (filename: ./modules/${filename}) hostModulesFilenames;
in
{
  imports = hostModules ++ [ ./hardware-configuration.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # user configuration
  users.users.root.openssh.authorizedKeys.keys = config.fugi.authorizedKeys;

  system.stateVersion = "24.05";
}
