{ config, pkgs, ... }:
let
  hostModulesFilenames = builtins.attrNames (builtins.readDir ./modules);
  hostModules = map (filename: ./modules + "/${filename}") hostModulesFilenames;
in
{
  imports = hostModules ++ [ ./hardware-configuration.nix ];

  # static ip
  fugi.staticIPv4 = {
    address = "192.168.0.3";
    prefixLength = 24;
  };
  fugi.staticIPv6 = {
    address = "fd00::3";
    prefixLength = 64;
  };

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

  users.users.fugi = {
    isNormalUser = true;
    home = "/home/fugi";
    openssh.authorizedKeys.keys = config.fugi.authorizedKeys;
    extraGroups = [ "media" ];
    packages = with pkgs; [
      ffmpeg
      yt-dlp
      mediainfo
      ffsend
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}

