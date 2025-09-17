{ ... }:
{
  programs.less = {
    enable = true;
    # horizontal scrolling in smaller steps instead of half page
    config = ''
      \\eOD noaction 20\\e(
      \\eOC noaction 20\\e)
    '';
  };

  home.sessionVariables = {
    LESS = "-FSR";
  };
}
