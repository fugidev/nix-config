{ ... }:
{
  services.swaync = {
    enable = true;

    settings = {
      widgets = [
        "inhibitors"
        "title"
        "dnd"
        "notifications"
        "mpris"
      ];
    };

    style = ''
      .control-center {
        padding: 16px;
      }
    '';
  };
}
