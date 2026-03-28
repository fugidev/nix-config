{ machineConfig, ... }:
{
  services.part-db = {
    enable = true;
    enablePostgresql = true;
    enableNginx = true;
    virtualHost = "parts.${machineConfig.baseDomain}";

    settings = {
      DEFAULT_LANG = "en";
      DEFAULT_TIMEZONE = "Europe/Berlin";
      BASE_CURRENCY = "EUR";
      CHECK_FOR_UPDATES = "0";
    };
  };
}
