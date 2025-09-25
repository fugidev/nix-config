{ config, pkgs, lib, ... }: {

  imports = [
    ./user-options.nix
    ./zsh.nix
    ./git.nix
    ./foot.nix
    ./direnv.nix
    ./helix.nix
    ./sftpman.nix
    ./mail.nix
    ./ssh.nix
    ./gpg.nix
  ];

  programs.zsh.profileExtra = ''
    if uwsm check may-start; then
      exec uwsm start -- sway-uwsm.desktop
    fi
  '';

  home.username = "fugi";
  home.homeDirectory = "/home/fugi";

  home.packages = with pkgs; [
    ffmpeg
    yt-dlp
    mediainfo
    sops
    trash-cli
    (runCommand "app2unit_xdg-open" { } ''
      mkdir -p $out/bin
      ln -s ${lib.getExe app2unit} $out/bin/xdg-open
    '')
  ] ++ lib.optionals config.fugi.guiApps [
    ## utils
    firefox
    xed-editor
    file-roller
    qalculate-gtk
    remmina
    filezilla
    mission-center
    ## media
    mpv
    feh
    pwvucontrol
    ## office
    naps2
    ## development
    vscodium
    meld
  ];

  # Allow jellyfin-media-player to get controlled via mpris
  # xdg.dataFile."jellyfinmediaplayer/scripts/mpris.so".source = "${pkgs.mpvScripts.mpris}/share/mpv/scripts/mpris.so";
}
