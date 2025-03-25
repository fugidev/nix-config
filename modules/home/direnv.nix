{ lib, ... }:
{
  programs.direnv = {
    enable = true;
    stdlib = /* sh */ ''
      # use centralized cache directory
      # see https://github.com/direnv/direnv/wiki/Customizing-cache-location
      : ''${XDG_CACHE_HOME:=$HOME/.cache}
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
        echo "''${direnv_layout_dirs[$PWD]:=$(
          echo -n "$XDG_CACHE_HOME"/direnv/layouts/
          echo -n "$PWD" | sha1sum | cut -d ' ' -f 1
        )}"
      }
    '';
    nix-direnv.enable = true;
  };

  # hack to make direnv less noisy
  programs.zsh.initExtra = lib.mkAfter /* sh */ ''
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
