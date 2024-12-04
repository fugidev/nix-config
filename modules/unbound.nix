{ ... }:
let
  confDir = "/etc/unbound/unbound.conf.d";
in
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
      include = "${confDir}/*.conf";
    };
  };

  systemd.tmpfiles.settings."10-unbound.conf.d" = {
    ${confDir}.d = {
      mode = "0755";
      user = "root";
      group = "root";
    };
  };
}
