{ lib, osConfig, ... }:
{
  programs.git = {
    enable = true;

    settings = {
      init.defaultBranch = "main";

      push.default = "current";

      gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";

      color = {
        diff-highlight = {
          oldNormal = "red";
          oldHighlight = "normal 88";
          newNormal = "green";
          newHighlight = "normal 22";
        };
      };
    };
  };

  home.file.".config/git/allowed_signers".text = (
    lib.concatMapStringsSep "\n" (s: "*@fugi.dev ${s}") osConfig.fugi.authorizedKeys
  );

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
