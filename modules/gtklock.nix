{ ... }:
{
  programs.gtklock = {
    enable = true;
    style = ''
      window {
        background-color: black;
        background-size: cover;
      }
    '';

    config.main = {
      start-hidden = true;
      idle-hide = true;
      idle-timeout = 10;
      follow-focus = true;
    };
  };
}
