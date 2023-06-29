{ config, lib, pkgs, ... }:
{
  programs.helix = {
    enable = true;

    package = pkgs.helix.overrideAttrs (old: {
      # https://github.com/helix-editor/helix/pull/7215
      patches = [ ./_helix_7215.patch ];
    });

    settings = {
      theme = "onedark-fugi";

      editor = {
        middle-click-paste = false;
        line-number = "relative";
        color-modes = true;
        true-color = true;
        cursor-shape.insert = "bar";
        whitespace = {
          render = {
            #space = "all"; # no trailing option yet :/
            space = "trailing";
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

  home.packages = with pkgs; [
    rust-analyzer
    nil
  ];
}
