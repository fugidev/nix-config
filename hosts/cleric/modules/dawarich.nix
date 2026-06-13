{ machineConfig, ... }:
{
  services.dawarich = {
    enable = true;
    localDomain = "dawarich.${machineConfig.baseDomain}";
    webPort = 3001;
  };
}
