{
  programs.foot = {
    enable = true;
    settings = {
      main.font = "monospace:size=10.5";

      colors = {
        foreground = "dddddd";
        background = "111111";

        regular0 = "090909";
        regular1 = "eb4e3d";
        regular2 = "76d672";
        regular3 = "f7ce46";
        regular4 = "4193f7";
        regular5 = "eb445a";
        regular6 = "78c5f5";
        regular7 = "ffffff";

        bright0 = "686868";
        bright1 = "eb4e3d";
        bright2 = "76d672";
        bright3 = "f7ce46";
        bright4 = "4193f7";
        bright5 = "eb445a";
        bright6 = "78c5f5";
        bright7 = "ffffff";
      };

      scrollback.multiplier = 3.0;
      scrollback.lines = 100000;
    };
  };

  xdg.desktopEntries."foot-bash" = {
    name = "Foot (bash)";
    genericName = "Terminal";
    exec = "foot bash";
    icon = "foot";
    categories = [ "System" "TerminalEmulator" ];
    settings = {
      Keywords = "shell;prompt;command;commandline;";
      StartupWMClass = "foot";
    };
  };

  home.file.".config/xfce4/helpers.rc".text = ''
    TerminalEmulator=foot
  '';
}
