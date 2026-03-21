{ util, machineConfig, ... }:
{
  imports = [
    (util.useFromUnstable {
      modules = [ "services/home-automation/home-assistant.nix" ];
      pkgs = [ "home-assistant" ];
    })
  ];

  services.home-assistant = {
    enable = true;

    extraPackages = ps: with ps; [
      psycopg2
    ];

    extraComponents = [
      ## Components required to complete the onboarding
      # "analytics"
      "google_translate"
      "met"
      # "radio_browser"
      "shopping_list"
      ## Recommended for fast zlib compression
      "isal"
      ## FRITZ!SmartHome
      "fritzbox"
    ];

    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};

      http = {
        server_host = "::1";
        trusted_proxies = [ "::1" ];
        use_x_forwarded_for = true;
      };

      recorder.db_url = "postgresql://@/hass";
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "hass" ];
    ensureUsers = [{
      name = "hass";
      ensureDBOwnership = true;
    }];
  };

  services.nginx.virtualHosts."hass.${machineConfig.baseDomain}" = {
    extraConfig = ''
      proxy_buffering off;
    '';
    locations."/" = {
      proxyPass = "http://[::1]:8123";
      proxyWebsockets = true;
    };
  };
}
