{ ... }:
{
  programs.less = {
    enable = true;
    # horizontal scrolling in smaller steps instead of half page
    keys = ''
      \\eOD noaction 20\\e(
      \\eOC noaction 20\\e)
    '';
  };

  home.sessionVariables = {
    LESS = "-FSR";
  };
}
