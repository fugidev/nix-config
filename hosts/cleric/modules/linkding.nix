{ machineConfig, ... }:
{
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      linkding = {
        image = "sissbruecker/linkding:latest";
        autoStart = true;
        ports = [ "127.0.0.1:9090:9090" ];
        volumes = [ "linkding_data:/etc/linkding/data" ];
        # fix memory allocation error
        extraOptions = [ "--ulimit" "nofile=1048576:1048576" ];
      };
    };
  };

  services.nginx.virtualHosts."linkding.${machineConfig.baseDomain}" = {
    locations."/".proxyPass = "http://127.0.0.1:9090";
  };
}
