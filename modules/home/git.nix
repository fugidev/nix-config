{ ... }:
{
  programs.git = {
    enable = true;

    signing = {
      key = "BF37903AE6FD294C4C674EE24472A20091BFA792";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "Lyn";
        email = "me@fugi.dev";
      };

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
  };

  programs.diff-so-fancy = {
    enable = true;
    enableGitIntegration = true;
    pagerOpts = [ ];
    settings = {
      changeHunkIndicators = false;
      stripLeadingSymbols = false;
      markEmptyLines = false;
      rulerWidth = 80;
    };
  };
}
