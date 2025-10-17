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

  # wait for gpu
  services.udev.extraRules = ''
    SUBSYSTEM=="drm", KERNEL=="card*", TAG+="systemd"
  '';

  # window manager
  programs.sway.enable = true;
  programs.sway.extraPackages = [ ];
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

  nixpkgs.overlays = [
    (final: prev: {
      wlroots_0_19 = prev.wlroots_0_19.overrideAttrs (old: {
        patches = old.patches ++ [
          (prev.fetchpatch {
            url = "https://gitlab.freedesktop.org/wlroots/wlroots/-/commit/7392b3313a7b483c61f4fea648ba8f2aa4ce8798.patch";
            hash = "sha256-SK463pnIX2qjwRblCJRbvJeZTL6wAXho6wBIJ10OuNk=";
          })
        ];
      });
    })
  ];
}
