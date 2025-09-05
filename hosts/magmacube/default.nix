{ config, pkgs, util, ... }:
{
  imports = [ ./hardware-configuration.nix ] ++ (util.dirPaths ./modules);

  home-manager.users.fugi.imports = util.dirPaths ./home;

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      editor = false;
    };
    efi.canTouchEfiVariables = false;
    timeout = 1;
  };

  # use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = config.fugi.authorizedKeys;

  fugi.allowUnfree = [
    "discord"
    "spotify"
    "vintagestory"
  ];

  fugi.allowInsecure = [
    "dotnet-runtime-7.0.20"
    "qtwebengine-5.15.19" # jellyfin-media-player
  ];

  systemd.services.greetd.unitConfig = {
    After = [ "sys-devices-pci0000:00-0000:00:03.1-0000:07:00.0-0000:08:00.0-0000:09:00.0-drm-card1.device" ];
    Wants = [ "sys-devices-pci0000:00-0000:00:03.1-0000:07:00.0-0000:08:00.0-0000:09:00.0-drm-card1.device" ];
  };

  programs.gtklock.config.main.monitor-priority = "DP-1";

  system.stateVersion = "24.05";
}
