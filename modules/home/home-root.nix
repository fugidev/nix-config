{
  imports = [
    ./user-options.nix
    ./zsh.nix
    ./helix.nix
  ];

  programs.zsh.sessionVariables = {
    # allow running nh as root
    NH_BYPASS_ROOT_CHECK = true;
    # use nix-daemon even when root
    NIX_REMOTE = "daemon";
  };

  home.username = "root";
  home.homeDirectory = "/root";
}
