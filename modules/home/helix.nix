{ lib, pkgs, ... }:
{
  programs.helix = {
    enable = true;

    package = pkgs.helix.overrideAttrs (_old: {
      # trailing spaces
      # patches = [
      #   (pkgs.fetchpatch {
      #     url = "https://web.archive.org/web/20240723091032id_/https://patch-diff.githubusercontent.com/raw/helix-editor/helix/pull/7215.patch";
      #     hash = "sha256-N25n7Lcdz7wKUHXaWQ+7PuJcmscDXx77qFOWUlXqX4I=";
      #     decode = "gunzip";
      #   })
      # ];
    });

    settings = {
      theme = "onedark-fugi";

      editor = {
        middle-click-paste = false;
        line-number = "relative";
        color-modes = true;
        true-color = true;
        cursor-shape.insert = "bar";
        auto-format = false;
        whitespace = {
          render = {
            # space = "all"; # no trailing option yet :/
            # space = "trailing";
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
