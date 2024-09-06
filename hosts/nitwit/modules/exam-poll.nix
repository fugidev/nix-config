{ config, inputs, machineConfig, ... }:
let
  cfg = config.services.exam-poll;
in
{
  imports = [
    inputs.exam-poll.nixosModules.default
  ];

  services.exam-poll = {
    enable = true;
    frontend = {
      port = 8129;
      hostName = "poll.${machineConfig.baseDomain}";
    };
    backend = {
      port = 8192;
      hostName = "poll-api.${machineConfig.baseDomain}";
    };
    mongodb = {
      uri = "mongodb://localhost:27017";
      database = "exam-poll";
      collection = "polls";
    };
  };

  services.nginx.virtualHosts = {
    ${cfg.frontend.hostName}.enableACME = false;
    ${cfg.backend.hostName}.enableACME = false;
  };

  # Annoyingly, MongoDB is not feasible without Docker.
  # (And Podman does not work for other reasons.)
  virtualisation = {
    docker.enable = true;
    oci-containers.backend = "docker";
    oci-containers.containers = {
      mongodb = {
        image = "mongo:5";
        autoStart = true;
        ports = [ "127.0.0.1:27017:27017" ];
      };
    };
  };
}
