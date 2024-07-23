{ inputs, ... }:
{
  imports = [
    ./zsh.nix
    ./less.nix
    ./git.nix
    ./helix.nix
    ./ssh.nix
    ./alacritty.nix
  ];

  nix.registry.nixpkgs.flake = inputs.nixpkgs-unstable;

  programs.home-manager.enable = true;

  home.username = "fugi";
  home.homeDirectory = "/Users/fugi";

  programs.zsh = {
    completionInit = ''
      fpath+=(/opt/homebrew/share/zsh/site-functions)
    '';
    envExtra = ''
      export PATH="/usr/local/bin:$PATH"

      eval "$(/opt/homebrew/bin/brew shellenv)"

      #export PATH="/opt/homebrew/opt/node@18/bin:$PATH"
      export PATH="/opt/homebrew/opt/node@20/bin:$PATH"
      export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
      export PATH="/Users/fugi/fvm/default/bin:$PATH"
    '';
  };
}
