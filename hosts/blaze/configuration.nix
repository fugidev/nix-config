# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
  nixos-m1 = builtins.fetchTarball {
    url = "https://github.com/tpwrules/nixos-m1/archive/refs/tags/release-2023-01-18.tar.gz";
    sha256 = "1znz3lm5spq62jygp2ha3ypgpyy45s09rvk6xdfvbw55223qvc53";
  };

  m1-support = nixos-m1 + "/nix/m1-support";
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Include the necessary packages and configuration for Apple M1 support.
    m1-support
  ];

  # Peripheral Firmware cannot be used directly from efi partition.
  #   cp /boot/asahi/{all_firmware.tar.gz,kernelcache*} hosts/blaze/firmware
  #   git add -N hosts/nixos/firmware
  # Do not commit these files.
  hardware.asahi.peripheralFirmwareDirectory = ./firmware;

  # enable backlight control
  hardware.acpilight.enable = true;

  boot.loader = {
    # Use the systemd-boot EFI boot loader.
    systemd-boot = {
      enable = true;
      #consoleMode = "max";
      editor = false;
    };

    efi.canTouchEfiVariables = false;

    timeout = 1;
  };

  # Increase tmpfs size
  services.logind.extraConfig = "RuntimeDirectorySize=6G";

  # lock session when closing lid
  services.logind.lidSwitch = "lock";

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
  security.rtkit.enable = true; # optional but recommended
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };

  # Enable bluetooth.
  #hardware.bluetooth.enable = true;
  #services.blueman.enable = true;

  # Enable gvfs
  services.gvfs = {
    enable = true;
    package = lib.mkForce pkgs.gnome.gvfs;
  };

  # Enable GnuPG
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "qt";
    enableSSHSupport = true;
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
    ];
  };

  # Enable polkit
  security.polkit.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpi
    lxqt.lxqt-policykit
    pinentry
    pinentry-curses
    pinentry-qt
    sshfs
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
