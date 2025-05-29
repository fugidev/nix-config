{ ... }:
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
    config = {
      global.hide_env_diff = true;
    };
    nix-direnv.enable = true;
  };
}
