{ config, lib, ... }:
{
  programs.alacritty = {
    enable = true;

    settings = {
      shell = lib.getExe config.programs.zsh.package;

      font = {
        normal.family = "Fira Code";
        size = 13;
      };

      colors = rec {
        primary = {
          foreground = "#dddddd";
          background = "#111111";
          # background = "#14191e";
        };
        normal = {
          black = "#090909";
          red = "#eb4e3d";
          green = "#76d672";
          yellow = "#f7ce46";
          blue = "#4193f7";
          magenta = "#eb445a";
          cyan = "#78c5f5";
          white = "#ffffff";
        };
        bright = {
          black = "#686868";
          red = "#eb4e3d";
          green = "#76d672";
          yellow = "#f7ce46";
          blue = "#4193f7";
          magenta = "#eb445a";
          cyan = "#78c5f5";
          white = "#ffffff";
        };
        hints = {
          start = {
            background = normal.yellow;
            foreground = normal.black;
          };
          end = {
            background = "#a08734";
            foreground = normal.black;
          };
        };
      };

      cursor.style.shape = "Beam";

      keyboard.bindings = [{
        key = "N";
        mods = "Command | Shift";
        action = "SpawnNewInstance";
      }];

      hints.enabled = [{
        command = "open";
        hyperlinks = true;
        post_processing = true;
        persist = false;
        mouse = {
          enabled = true;
          mods = "Command";
        };
        binding = {
          key = "O";
          mods = "Command|Shift";
        };
        regex = lib.removeSuffix "\n" ''
          (ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|file:|git://|ssh:|ftp://)[^\u0000-\u001F\u007F-\u009F<>"\\s{-}\\^⟨⟩`]+
        '';
      }];
    };
  };

  home.sessionVariables = {
    # required for colors to work in less/manpages
    GROFF_NO_SGR = 1;
  };
}
