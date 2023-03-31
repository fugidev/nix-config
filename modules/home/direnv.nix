{ config, lib, pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # load direnv + a little hack to make it less noisy
  home.file.".zshrc".text = ''
    eval "$(direnv hook zsh)"

    _copy_function() {
      test -n "$(declare -f "$1")" || return
      eval "''${_/$1/$2}"
    }

    _copy_function _direnv_hook _direnv_hook__old
    unset -f _copy_function

    _direnv_hook() {
      _direnv_hook__old "$@" 2> >(egrep -v --color=never '^direnv: (export|unloading)')
    }
  '';
}
