{ pkgs, ... }:
{
  imports = [
    ./plymouth.nix
    ./greetd.nix
    ./uwsm.nix
    ./fonts.nix
    ./printing.nix
    ./ios-support.nix
    ./thunar.nix
    ./gtklock.nix
    ./librepods.nix
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
  programs.librepods.enable = true;

  programs.kdeconnect.enable = true;

  # Enable gvfs
  services.gvfs.enable = true;

  # secret service
  services.gnome.gnome-keyring.enable = true;

  # Enable polkit
  security.polkit.enable = true;

  # packages installed in system profile
  environment.systemPackages = with pkgs; [
    sshfs
  ];

  # wait for gpu
  services.udev.extraRules = ''
    SUBSYSTEM=="drm", KERNEL=="card*", TAG+="systemd"
  '';

  # window manager
  programs.sway = {
    enable = true;
    package = null;
    extraPackages = [ ];
  };
  xdg.portal.enable = true;
  # power key is handled by window manager
  services.logind.settings.Login.HandlePowerKey = "ignore";

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
