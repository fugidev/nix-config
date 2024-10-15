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
    xfce.thunar
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
}
