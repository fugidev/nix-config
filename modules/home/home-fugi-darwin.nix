{ lib, pkgs, ... }:
{
  imports = [
    ./zsh.nix
    ./less.nix
    ./git.nix
    ./helix.nix
    ./ssh.nix
    ./alacritty.nix
    ./gpg-darwin.nix
    ./direnv.nix
    ./sftpman.nix
  ];

  home.username = "fugi";
  home.homeDirectory = "/Users/fugi";

  home.packages = with pkgs; [
    fd
    ripgrep
    curl
    wget
    git
    eza
    doggo
    jq
    ncdu
    nmap
    nix-output-monitor
    ffmpeg
    yt-dlp
  ];

  programs.zsh =
    let
      homebrew = "/opt/homebrew";
      binDirs = [
        "/Users/fugi/fvm/default"
        "${homebrew}/opt/openjdk"
        "${homebrew}/opt/node@20"
        # "${homebrew}/opt/node@18"
      ];
    in
    {
      completionInit = ''
        fpath+=(${homebrew}/share/zsh/site-functions)
      '';
      envExtra = ''
        export PATH="/usr/local/bin:$PATH"

        eval "$(${homebrew}/bin/brew shellenv)"

        export PATH="${lib.makeBinPath binDirs}:$PATH"
      '';
    };

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      style = "plain";
    };
  };

  programs.nh = {
    enable = true;
    flake = "/Users/fugi/.config/home-manager";
  };

  programs.sftpman.package = pkgs.sftpman.overrideAttrs {
    postPatch = ''
      substituteInPlace sftpman/model.py \
        --replace-fail '/mnt/sshfs/' '/Users/fugi/.cache/sshfs/' \
        --replace-fail 'fusermount -u' 'umount' \
        --replace-fail 'mount -l' 'mount' \
        --replace-fail 'type fuse\.sshfs' '.*macfuse'
    '';
  };
}
