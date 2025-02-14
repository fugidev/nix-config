{ pkgs, ... }:
{
  imports = [
    ./greetd.nix
    ./fonts.nix
    ./printing.nix
    ./ios-support.nix
    ./thunar.nix
  ];

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable bluetooth.
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable gvfs
  services.gvfs.enable = true;

  # secret service
  services.gnome.gnome-keyring.enable = true;

  # Enable polkit
  security.polkit.enable = true;

  # packages installed in system profile
  environment.systemPackages = with pkgs; [
    pinentry
    pinentry-curses
    pinentry-qt
    sshfs
  ];

  # window manager
  programs.sway.enable = true;
  xdg.portal.enable = true;

  # Define user account.
  users.users.fugi = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "networkmanager"
      "dialout"
    ];
  };

  # home-manager
  home-manager.users.fugi = {
    imports = [ ./home/home-fugi.nix ];
    fugi.guiApps = true;
  };

  fugi.allowUnfree = [ "apple_cursor" ];
}
