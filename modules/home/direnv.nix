{ config, lib, pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # hack to make direnv less noisy
  programs.zsh.initExtra = lib.mkAfter ''
    _copy_function() {
      test -n "$(declare -f "$1")" || return
      eval "''${_/$1/$2}"
    }

    _copy_function _direnv_hook _direnv_hook__old
    unset -f _copy_function

    _direnv_hook() {
      _direnv_hook__old "$@" 2> >(grep -E -v --color=never '^direnv: export')
    }
  '';
}
