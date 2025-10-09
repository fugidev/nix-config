{ machineConfig, ... }:
{
  services.nginx.virtualHosts."poll.${machineConfig.baseDomain}" = {
    locations."/" = {
      root = "/srv/exam-poll";
      tryFiles = "$uri $uri.html $uri/ =404";
      extraConfig = ''
        error_page 404 /404.html;
      '';
    };
  };

  systemd.tmpfiles.settings."exam-poll" = {
    "/srv/exam-poll".d = {
      mode = "0550";
      user = "nginx";
      group = "nginx";
    };
  };
}
