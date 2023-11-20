{ config, lib, pkgs, ... }:
{
  options = with lib; {
    fugi.promptColor = mkOption {
      type = types.str;
      description = "zsh prompt color";
      default = "blue";
    };
  };

  config = {
    users.defaultUserShell = pkgs.zsh;

    environment.shellAliases = lib.mkForce { };

    programs.fzf.keybindings = true;

    programs.zsh = {
      enable = true;

      # prevent prompt from being overridden
      promptInit = "";

      # zshenv
      shellInit = /* zsh */ ''
        # disable setup wizard
        zsh-newuser-install () {}
      '';

      # zshrc
      interactiveShellInit = /* zsh */ ''
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
        grml_theme_add_token chevron $'%f%(!.#.\U00BB) '

        # prompt items
        zstyle ':prompt:hw:left:setup' items ip-netns virtual-env change-root time user at host path vcs chevron
        zstyle ':prompt:hw:right:setup' items rc

        # vcs style
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
      };

      autosuggestions.enable = true;
    };

    nixpkgs.overlays = [
      (_self: super: {
        zsh = super.zsh.overrideAttrs
          (_: {
            patches = [
              # disable double escaping of remote paths for rsync/scp completion
              ../misc/zsh_completion_remote_files.patch
            ];
          });
      })
    ];
  };
}
