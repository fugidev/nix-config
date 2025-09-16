{ ... }:
{
  programs.git = {
    enable = true;
    userName = "Fugi";
    userEmail = "me@fugi.dev";

    signing = {
      key = "BF37903AE6FD294C4C674EE24472A20091BFA792";
      signByDefault = true;
    };

    extraConfig = {
      init.defaultBranch = "main";

      push.default = "current";

      tag.gpgSign = false;

      color = {
        diff-highlight = {
          oldNormal = "red";
          oldHighlight = "normal 88";
          newNormal = "green";
          newHighlight= "normal 22";
        };
      };
    };

    diff-so-fancy = {
      enable = true;
      changeHunkIndicators = false;
      stripLeadingSymbols = false;
      markEmptyLines = false;
      pagerOpts = [ ];
      rulerWidth = 80;
    };
  };
}
