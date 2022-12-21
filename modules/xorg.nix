{ config, pkgs, lib, ... }: {

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    # Enable touchpad.
    libinput = {
      enable = true;

      touchpad = {
        tapping = false;
        naturalScrolling = true;
      };
    };

    displayManager = {
      # autologin
      lightdm.greeter.enable = false;
      autoLogin = {
        enable = true;
        user = "fugi";
      };

      # xsession managed by home-manager
      defaultSession = "xsession";
      session = [{
        manage = "desktop";
        name = "xsession";
        start = ''
          exec $HOME/.xsession
        '';
      }];
    };

    # Disable xterm
    excludePackages = [ pkgs.xterm ];

    # HiDPI
    dpi = 144;

    # Configure keymap in X11
    layout = "de";
  };
}
