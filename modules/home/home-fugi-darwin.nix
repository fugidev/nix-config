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
}
