{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [ betterlockscreen ];

  services.screen-locker = {
    enable = true;
    lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l";
  };

  # systemd unit to generate betterlockscreen cache
  systemd.user.services = {
    betterlockscreen-generate = {
      Unit.Description = "Generate betterlockscreen cache";
      Service = {
        Type = "oneshot";
        # pass `--fx` without specifying any effects to speed up activation
        ExecStart = "${pkgs.betterlockscreen}/bin/betterlockscreen -u ${config.fugi.wallpaper} --fx";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };

  home.activation = {
    # restart xss-lock.service to apply lockCmd changes
    restart-xss-lock = ''
      $DRY_RUN_CMD systemctl --user restart xss-lock.service
    '';

    # generate cache
    start-betterlockscreen-generate = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD systemctl --user start betterlockscreen-generate.service
    '';
  };
}
