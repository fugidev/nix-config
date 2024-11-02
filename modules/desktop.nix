{ pkgs, ... }:
{
  imports = [
    ./greetd.nix
    ./fonts.nix
    ./printing.nix
    ./ios-support.nix
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

  # Enable polkit
  security.polkit.enable = true;

  # packages installed in system profile
  environment.systemPackages = with pkgs; [
    pinentry
    pinentry-curses
    pinentry-qt
    sshfs
  ];

  fugi.allowUnfree = [ "apple_cursor" ];
}