{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      ttf_bitstream_vera
      twitter-color-emoji # emoji
      fira-code # mono
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];

    # Bitstream Vera (base) -> Twemoji -> DejaVu (rest)
    # to prevent DejaVu symbols taking precendence over Twemoji
    fontconfig = {
      defaultFonts = {
        serif = [
          "Bitstream Vera Serif"
          "Twitter Color Emoji"
          "DejaVu Serif"
        ];
        sansSerif = [
          "Bitstream Vera Sans"
          "Twitter Color Emoji"
          "DejaVu Sans"
        ];
        monospace = [
          "Fira Code"
          # "FiraCode Nerd Font" # breaks waybar icons
          "Twitter Color Emoji"
          "DejaVu Sans Mono"
        ];
        emoji = [
          "Twitter Color Emoji"
        ];
      };
    };
  };
}
