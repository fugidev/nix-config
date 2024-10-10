{ ... }:
{
  # use unbound as local dns resolver
  services.resolved.enable = false;
  services.unbound = {
    enable = true;
    localControlSocketPath = "/run/unbound/unbound.ctl";
    settings = {
      server = {
        prefetch = true;
      };
    };
  };
}
