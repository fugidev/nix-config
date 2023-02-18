{ config, pkgs, lib, ... }:
let
  ttf-twemoji = pkgs.callPackage ../pkgs/ttf-twemoji { };
in
{
  fonts = {
    fonts = with pkgs; [
      ttf_bitstream_vera
      fira-code # mono
      ttf-twemoji # emoji
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
