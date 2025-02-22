{ config, pkgs, lib, ... }: {

  imports = [
    ./user-options.nix
    ./zsh.nix
    ./git.nix
    ./foot.nix
    ./direnv.nix
    ./helix.nix
    ./dunst.nix
    ./sftpman.nix
    ./mail.nix
    ./ssh.nix
    ./gpg.nix
  ];

  home.username = "fugi";
  home.homeDirectory = "/home/fugi";

  home.packages = with pkgs; [
    ffsend
    ffmpeg
    yt-dlp
    mediainfo
    sops
    trash-cli
  ] ++ lib.optionals config.fugi.guiApps [
    firefox
    xed-editor
    file-roller
    # utils
    qalculate-gtk
    remmina
    filezilla
    # media
    mpv
    feh
    pavucontrol
    jellyfin-media-player
    # office
    skanlite
    # development
    vscodium
    meld
  ] ++ lib.optionals (config.fugi.guiApps && !pkgs.naps2.meta.broken) [
    naps2
  ];

  # Allow jellyfin-media-player to get controlled via mpris
  xdg.dataFile."jellyfinmediaplayer/scripts/mpris.so".source = "${pkgs.mpvScripts.mpris}/share/mpv/scripts/mpris.so";
}
