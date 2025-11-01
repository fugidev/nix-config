{ pkgs, flakeRoot, ... }:
{
  imports = map (x: flakeRoot + "/modules/home/${x}") [
    "zsh.nix"
    "less.nix"
    "git.nix"
    "helix.nix"
    "ssh.nix"
    "alacritty.nix"
    "direnv.nix"
    "sftpman.nix"
    "librewolf.nix"
  ];

  fugi.promptColor = "#f7ce46"; # yellow

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    ffmpeg
    yt-dlp
    mediainfo
  ];

  programs.nh = {
    enable = true;
    flake = "/etc/nix-darwin";
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      style = "plain";
    };
  };

  # librewolf crashes, installed using brew instead
  programs.librewolf.package = null;
}
