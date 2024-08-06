{ pkgs, lib, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # enable edge config and beta gpu driver
  hardware.asahi.useExperimentalGPUDriver = true;
  hardware.asahi.experimentalGPUInstallMode = "replace";

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
  networking.hostName = "blaze";
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  # Environment variables
  environment.variables = {
    MOZ_USE_XINPUT2 = "1"; # firefox smooth scrolling
  };

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # font = "Lat2-Terminus16";
    keyMap = "de";
    # useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable sound.
  # sound.enable = true;
  security.rtkit.enable = true; # optional but recommended

  # Enable bluetooth.
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable gvfs
  services.gvfs = {
    enable = true;
    package = lib.mkForce pkgs.gnome.gvfs;
  };

  # Define user account.
  users.users.fugi = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’.
      "video" # Allow backlight control
      "networkmanager"
    ];
    packages = with pkgs; [
      ark
      firefox
      xfce.thunar
      feh
      pavucontrol
      vscodium
      filezilla
      meld
      sops
      ffmpeg
      yt-dlp
      ffsend
    ];
  };

  # Enable polkit
  security.polkit.enable = true;

  # packages installed in system profile
  environment.systemPackages = with pkgs; [
    acpi
    lxqt.lxqt-policykit
    pinentry
    pinentry-curses
    pinentry-qt
    sshfs
  ];

  nixpkgs.overlays = [
    (_self: super: {
      # build fd without jemalloc, doesn't support 16K pages
      fd = super.fd.overrideAttrs
        (_: {
          buildNoDefaultFeatures = true;
          buildFeatures = [ "completions" ];
        });
    })
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
