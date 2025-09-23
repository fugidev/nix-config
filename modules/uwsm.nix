{ pkgs, ... }:
{
  programs.uwsm = {
    enable = true;
    waylandCompositors.sway = {
      binPath = "/etc/profiles/per-user/fugi/bin/sway";
      prettyName = "Sway";
    };
  };

  environment.sessionVariables = {
    APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
  };

  environment.systemPackages = with pkgs; [
    app2unit
    xdg-terminal-exec
  ];
}
