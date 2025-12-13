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
    ./librewolf.nix
  ];

  programs.zsh.profileExtra = ''
    # start uwsm if not connected via ssh
    if ! pstree -s -p $$ | grep -q '\-sshd('; then
      if uwsm check may-start; then
        export UWSM_SILENT_START=1
        exec uwsm start -- sway-uwsm.desktop
      fi
    fi
  '';

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  home.username = "fugi";
  home.homeDirectory = "/home/fugi";

  home.packages = with pkgs; [
    ffmpeg
    yt-dlp
    mediainfo
    exiftool
    sops
    trash-cli
    (runCommand "app2unit_xdg-open" { } ''
      mkdir -p $out/bin
      ln -s ${lib.getExe app2unit} $out/bin/xdg-open
    '')
  ] ++ lib.optionals config.fugi.guiApps [
    ## utils
    xed-editor
    file-roller
    qalculate-gtk
    remmina
    filezilla
    mission-center
    intiface-engine
    ## media
    mpv
    feh
    pwvucontrol
    (jellyfin-chromium.override { jellyfinUrl = "https://jellyfin.librarian.fugi.dev/"; })
    ## office
    naps2
    ## development
    vscodium
    meld
    ## social
    tuba
    signal-desktop
  ];

  # Allow jellyfin-media-player to get controlled via mpris
  # xdg.dataFile."jellyfinmediaplayer/scripts/mpris.so".source = "${pkgs.mpvScripts.mpris}/share/mpv/scripts/mpris.so";
}
