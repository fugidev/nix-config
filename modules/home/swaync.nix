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

    style = /* css */ ''
      .control-center {
        padding: 16px;
        border-top-right-radius: 0;
        border-bottom-right-radius: 0;
      }

      .notification-group,
      .notification-row {
        background-color: transparent;
        padding-left: 0;
        padding-right: 0;
      }

      .notification-content {
        padding: 8px;
      }

      .notification-content .time {
        font-weight: normal;
      }

      .widget-mpris-player {
        background-color: rgba(0,0,0,.2);
      }
    '';
  };
}
