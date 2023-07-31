{ config, pkgs, lib, ... }:
let
  ttf-twemoji = pkgs.callPackage ../pkgs/ttf-twemoji { };
in
{
  fonts = {
    packages = with pkgs; [
      ttf_bitstream_vera
      ttf-twemoji # emoji
      fira-code # mono
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];

    # Bitstream Vera (base) -> Twemoji -> DejaVu (rest)
    # to prevent DejaVu symbols taking precendence over Twemoji
    fontconfig = {
      defaultFonts = {
        serif = [
          "Bitstream Vera Serif"
          "Twemoji"
          "DejaVu Serif"
        ];
        sansSerif = [
          "Bitstream Vera Sans"
          "Twemoji"
          "DejaVu Sans"
        ];
        monospace = [
          "Fira Code"
          # "FiraCode Nerd Font" # breaks waybar icons
          "Twemoji"
          "DejaVu Sans Mono"
        ];
        emoji = [
          "Twemoji"
        ];
      };
    };
  };
}
