{ pkgs, ... }: {
  programs.rofi = {
    enable = true;

    package = pkgs.rofi-wayland;

    theme = "Arc-Dark";
    font = "mono 12";

    extraConfig = {
      modi = "drun";
      show-icons = true;
    };
  };

  home.packages = with pkgs; [
    (rofimoji.override { rofi = rofi-wayland; })
  ];
}
