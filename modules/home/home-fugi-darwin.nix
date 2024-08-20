{ lib, ... }:
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
}
