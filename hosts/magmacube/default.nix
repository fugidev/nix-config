{ pkgs, util, ... }:
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

  console.keyMap = "de";

  networking.hostName = "magmacube";

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
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
