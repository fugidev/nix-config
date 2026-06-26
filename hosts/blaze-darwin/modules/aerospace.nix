{ lib, ... }:
let
  mod = "ctrl";

  workspaces = map toString (lib.range 1 9);
  workspaceKeybinds = map (ws: {
    "${mod}-${ws}" = "workspace ${ws}";
    "${mod}-shift-${ws}" = "move-node-to-workspace ${ws}";
  }) workspaces;

  directions = [
    "left"
    "right"
    "up"
    "down"
  ];
  directionalKeybinds = map (d: {
    "${mod}-${d}" = "focus ${d}";
    "${mod}-shift-${d}" = "move ${d}";
    "${mod}-alt-${d}" = "join-with ${d}";
  }) directions;
in
{
  services.aerospace = {
    enable = true;

    settings = {
      mode.main.binding = {
        "${mod}-f" = "fullscreen";
        "${mod}-enter" = "exec-and-forget open -n /Applications/Nix\\ Apps/Alacritty.app";
        "${mod}-e" = "layout tiles horizontal vertical";
        "${mod}-w" = "layout v_accordion";
        "${mod}-shift-space" = "layout floating tiling";
      }
      // lib.mergeAttrsList (workspaceKeybinds ++ directionalKeybinds);
    };
  };
}
