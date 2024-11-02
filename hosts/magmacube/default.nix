{ util, ... }:
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

  # Define user account.
  users.users.fugi = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "networkmanager"
    ];
  };

  fugi.allowUnfree = [
    "discord"
    "spotify"
  ];

  system.stateVersion = "24.05";
}
