{ lib, pkgs, ... }:
{
  imports = [
    ./zsh.nix
    ./less.nix
    ./git.nix
    ./helix.nix
    ./ssh.nix
    ./alacritty.nix
    ./direnv.nix
    ./sftpman.nix
    ./librewolf.nix
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
    htop
    btop
  ];

  programs.zsh =
    let
      homebrew = "/opt/homebrew";
    in
    {
      completionInit = ''
        fpath+=(${homebrew}/share/zsh/site-functions)
      '';
      envExtra = ''
        export PATH="/usr/local/bin:$PATH"

        eval "$(${homebrew}/bin/brew shellenv)"
      '';
      initContent = lib.mkAfter ''
        # Disable git integration in ~/.cache/sshfs
        zstyle ':vcs_info:*' disable-patterns "~/.cache/sshfs(|/*)"
      '';
    };

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      style = "plain";
    };
  };

  programs.sftpman.package = pkgs.sftpman-python.override {
    mountPath = "/Users/fugi/.cache/sshfs/";
  };

  # librewolf crashes, installed using brew instead
  programs.librewolf.package = null;
}
