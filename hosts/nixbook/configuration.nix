# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
  nixos-m1 = builtins.fetchTarball {
    url = "https://github.com/tpwrules/nixos-m1/archive/refs/tags/release-2022-12-18.tar.gz";
    sha256 = "1vbc9lr1qwhdj4gka47pimx71yf4bciqv220mwvzbhsn6x7qmmfj";
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
  #   cp /boot/asahi/{all_firmware.tar.gz,kernelcache*} hosts/nixbook/firmware
  #   git add -N hosts/nixos/firmware
  # Do not commit these files.
  hardware.asahi.peripheralFirmwareDirectory = ./firmware;

  boot.loader = {
    # Use the systemd-boot EFI boot loader.
    systemd-boot = {
      enable = true;
      consoleMode = "max";
      editor = false;
    };

    efi.canTouchEfiVariables = false;

    timeout = 1;
  };

  # Network Manager
  networking.hostName = "nixbook";
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput = {
    enable = true;

    touchpad = {
      tapping = false;
      naturalScrolling = true;
    };
  };

  # Environment variables
  environment.variables = {
    MOZ_USE_XINPUT2 = "1"; # firefox smooth scrolling
  };

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "de";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.background = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
  services.xserver.displayManager.lightdm.greeters.gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
  };

  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      i3lock #default i3 screen locker
      i3blocks #if you are planning on using i3blocks over i3status
      rofi # application launcher
   ];
  };

  # Disable xterm
  services.xserver.excludePackages = [ pkgs.xterm ];

  # HiDPI
  services.xserver.dpi = 144;

  # Configure keymap in X11
  services.xserver.layout = "de";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable sound.
  security.rtkit.enable = true; # optional but recommended
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Enable bluetooth.
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

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
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      firefox
      neofetch
      xfce.thunar
      alacritty
      feh
      pavucontrol
      vscodium
      filezilla
      meld
    ];
  };

  # root user
  users.users.root.shell = lib.mkForce pkgs.zsh;

  # fonts
  fonts.fonts = with pkgs; [ fira-code ];

  # Enable polkit
  security.polkit.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gcc
    git
    htop
    btop
    acpi
    lxqt.lxqt-policykit
    bat
    fd
    pinentry
    pinentry-curses
    pinentry-qt
    sshfs
  ];

  # grml zsh
  programs.zsh.enable = true;
  programs.zsh.interactiveShellInit = ''
    source ${pkgs.grml-zsh-config}/etc/zsh/zshrc

    # Make user colour green in prompt instead of default blue
    #zstyle ':prompt:grml:left:items:user' pre '%F{green}%B'
  '';
  programs.zsh.promptInit = ""; # otherwise it'll override the grml prompt

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  nix.extraOptions = ''
    experimental-features = nix-command flakes
    allow-import-from-derivation = true
  '';
}
