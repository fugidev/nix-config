{ pkgs, ... }:
{
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird.overrideAttrs (old: {
      buildCommand = old.buildCommand + ''
        wrapProgram $out/bin/thunderbird \
          --set-default MOZ_ENABLE_WAYLAND 0
      '';
    });
    profiles."default" = {
      isDefault = true;
    };
  };

  home.packages = with pkgs; [
    birdtray
  ];
}
