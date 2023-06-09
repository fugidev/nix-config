{ config, lib, pkgs, ... }@args:
{
  programs.zsh = {
    enable = true;

    initExtra = /* zsh */ ''
      source ${pkgs.agdsn-zsh-config}/etc/zsh/zshrc

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

      # Disable ssh/rsync user completion
      zstyle ':completion:*:ssh:*' users
      zstyle ':completion:*:rsync:*' users

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

    shellAliases = {
      # like `glol` but with stat
      glost = "git log --graph --pretty='format:%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset%n' --abbrev-commit --compact-summary";
      glosta = "glost --all";
    } // lib.optionalAttrs (! args ? "nixosConfig") {
      # disabled on nixos
      dco = "docker compose";
      dcb = "docker compose build";
      dcdn = "docker compose down";
      dce = "docker compose exec";
      dcl = "docker compose logs";
      dclf = "docker compose logs -f";
      dcps = "docker compose ps";
      dcpull = "docker compose pull";
      dcrestart = "docker compose restart";
      dcrm = "docker compose rm";
      dcstart = "docker compose start";
      dcstop = "docker compose stop";
      dcup = "docker compose up";
      dcupb = "docker compose up --build";
      dcupdb = "docker compose up -d --build";
      dcupd = "docker compose up -d";
      dtop = "docker top";
      hms = "home-manager switch";
    };
  };
}
