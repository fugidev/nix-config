{ config, lib, pkgs, ... }:
let
  # https://github.com/helix-editor/helix/pull/7215
  trailingSpacesPatch = pkgs.fetchpatch {
    url = "https://github.com/helix-editor/helix/commit/60c06076b25ba5aa60fd4e0abb548a710bca542d.patch";
    hash = "sha256-T21KUGGPPVnNAoSaRjNQCIyyaImkq/cBcjcRsVUlKxM=";
  };
in
{
  programs.helix = {
    enable = true;

    package = pkgs.helix.overrideAttrs (old: {
      patches = [ trailingSpacesPatch ];
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
