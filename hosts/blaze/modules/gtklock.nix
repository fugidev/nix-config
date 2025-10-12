{ lib, pkgs, ... }:
let
  script = pkgs.writeShellApplication {
    name = "gtklock-runshell-script";
    runtimeInputs = with pkgs; [
      acpi
      coreutils
      gnused
    ];
    text = ''
      acpi -b \
      | cut -d: -f2- \
      | cut -c2- \
      | sed 's/^\(dis\)\?charging, //i' \
      | sed 's/:[0-9][0-9] /h /g' \
      | sed 's/^Full/Battery Full/'
    '';
  };
in
{
  programs.gtklock = {
    modules = with pkgs; [
      gtklock-runshell-module
    ];

    config.runshell = {
      runshell-position = "center-center";
      refresh = 30;
      command = lib.getExe script;
    };

    style = ''
      #runshell {
        font-size: 1rem;
        margin-top: 17rem;
      }
      window.focused:not(.hidden) #runshell {
        margin-top: 10rem;
      }
    '';
  };
}
