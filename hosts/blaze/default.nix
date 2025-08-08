{ pkgs, util, ... }:
{
  imports = [ ./hardware-configuration.nix ] ++ (util.dirPaths ./modules);

  home-manager.users.fugi.imports = util.dirPaths ./home;

  # enable edge config and beta gpu driver
  hardware.asahi.useExperimentalGPUDriver = true;
  hardware.asahi.experimentalGPUInstallMode = "replace";
  hardware.asahi.peripheralFirmwareDirectory = pkgs.requireFile {
    name = "asahi";
    hashMode = "recursive";
    hash = "sha256-Z/0QdtVTYTY7P/LzAYF4lJY/u+f5h56hssxJcqPFz4M=";
    message = ''
      nix-store --add-fixed sha256 --recursive /boot/asahi
      nix hash path /boot/asahi
    '';
  };

  # enable backlight control
  hardware.acpilight.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="leds", ACTION=="add", KERNEL=="kbd_backlight", \
      RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/leds/%k/brightness", \
      RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness"
  '';

  boot.loader = {
    # Use the systemd-boot EFI boot loader.
    systemd-boot = {
      enable = true;
      editor = false;
    };

    efi.canTouchEfiVariables = false;

    timeout = 1;
  };

  boot.kernelParams = [
    # switch fn key mode
    "hid_apple.fnmode=2"
    # swap fn and ctrl
    "hid_apple.swap_fn_leftctrl=1"
  ];

  # Increase tmpfs size
  services.logind.extraConfig = "RuntimeDirectorySize=6G";

  # Network Manager
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  # Environment variables
  environment.variables = {
    MOZ_USE_XINPUT2 = "1"; # firefox smooth scrolling
  };

  # packages installed in system profile
  environment.systemPackages = with pkgs; [
    acpi
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
