{ config, ... }:
{
  services.prometheus.exporters.unbound = {
    enable = true;
    unbound.host = "unix://${config.services.unbound.localControlSocketPath}";
  };
}
