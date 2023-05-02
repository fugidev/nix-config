{ config, lib, pkgs, ... }:
{
  programs.helix = {
    enable = true;

    settings = {
      theme = "onedark-fugi";

      editor = {
        middle-click-paste = false;
        line-number = "relative";
        color-modes = true;
        cursor-shape.insert = "bar";
        whitespace = {
          render = {
            #space = "all"; # no trailing option yet :/
            tab = "all";
          };
          characters = {
            space = "·";
            tab = "→";
            tabpad = "·";
          };
        };
        indent-guides = {
          render = true;
          character = "▏";
          skip-levels = 1;
        };
        soft-wrap.enable = true;
      };
    };

    themes = {
      onedark-fugi = lib.trivial.importTOML (pkgs.helix + /lib/runtime/themes/onedark.toml) // {
        "ui.background".bg = "#111111";
      };
    };
  };

  home.packages = with pkgs; [ rust-analyzer ];
}
