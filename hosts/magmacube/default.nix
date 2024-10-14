{ pkgs, ... }:
let
  homeModulesFilenames = builtins.attrNames (builtins.readDir ./home);
  homeModules = map (filename: ./home/${filename}) homeModulesFilenames;
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  home-manager.users.fugi.imports = homeModules;

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      editor = false;
    };
    efi.canTouchEfiVariables = false;
    timeout = 1;
  };

  console.keyMap = "de";

  networking.hostName = "magmacube";
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Define user account.
  users.users.fugi = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "networkmanager"
    ];
  };

  # Enable polkit
  security.polkit.enable = true;

  # packages installed in system profile
  environment.systemPackages = with pkgs; [
    lxqt.lxqt-policykit
    pinentry
    pinentry-curses
    pinentry-qt
    sshfs
  ];

  fugi.allowUnfree = [
    "apple_cursor"
    "discord"
    "spotify"
  ];

  system.stateVersion = "24.05";
}
