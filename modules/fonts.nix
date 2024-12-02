{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      ttf_bitstream_vera
      twitter-color-emoji # emoji
      fira-code # mono
      nerd-fonts.fira-code
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
