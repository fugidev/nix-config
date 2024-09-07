{ config, machineConfig, ... }:
let
  hostName = config.services.roundcube.hostName;
in
{
  services.roundcube = {
    hostName = "mail.${machineConfig.baseDomain}";
    enable = true;
    plugins = [ "managesieve" ];
    extraConfig = ''
      $config['imap_host'] = 'ssl://imap.migadu.com';
      $config['smtp_host'] = 'ssl://smtp.migadu.com';
    '';
  };

  # conflicts with wildcard cert setting
  services.nginx.virtualHosts.${hostName}.enableACME = false;
}
