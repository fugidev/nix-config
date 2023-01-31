{ config, lib, pkgs, ... }:
let
  agdsn-zsh-config = pkgs.callPackage ./pkgs/agdsn-zsh-config.nix { };
in
{
  users.defaultUserShell = pkgs.zsh;

  programs.zsh = {
    enable = true;

    shellAliases = lib.mkForce { };

    interactiveShellInit = ''
      source ${agdsn-zsh-config}/etc/zsh/zshrc

      # ctrl+backspace, ctrl+delete
      bindkey '\e[3;5~' kill-word
      bindkey '^H' backward-kill-word

      ## prompt

      # prompt user colour (default blue)
      if (( EUID != 0 )); then
        zstyle ':prompt:hw:*:items:user' pre '%B%F{${config.fugi.promptColor}}'
      fi

      # Disable git integration in /mnt
      zstyle ':vcs_info:*' disable-patterns "/mnt(|/*)"

      # chevron
      grml_theme_add_token chevron $'%f\U00BB '

      # prompt items
      zstyle ':prompt:hw:left:setup' items ip-netns virtual-env change-root time user at host path vcs chevron
      zstyle ':prompt:hw:right:setup' items rc

      # vsc style
      zstyle ':vcs_info:*' enable git
      zstyle ':vcs_info:*' check-for-changes true
      zstyle ':vcs_info:*' unstagedstr '!'
      zstyle ':vcs_info:*' stagedstr '+'
      zstyle ':vcs_info:git*' formats "%F{red}[%F{green}%b%F{yellow}%m%u%c%F{red}]%f "
    '';

    promptInit = ""; # otherwise it'll override the grml prompt
  };
}
