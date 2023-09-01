{ config, lib, pkgs, ... }: {
  time.timeZone = "Europe/Berlin";

  users.users.root.openssh.authorizedKeys.keys = config.fugi.authorizedKeys;

  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    shellAliases = lib.mkForce { };
    interactiveShellInit = ''
      source ${pkgs.agdsn-zsh-config}/etc/zsh/zshrc

      # ctrl+backspace, ctrl+delete
      bindkey '\e[3;5~' kill-word
      bindkey '^H' backward-kill-word
    '';
    shellInit = ''
      # disable setup wizard
      zsh-newuser-install () {}
    '';
    promptInit = "";
  };

  environment.systemPackages = with pkgs; [
    helix
    git
    fd
    exa
    ripgrep
    wget
    doggo
  ];

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
