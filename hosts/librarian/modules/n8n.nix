{ config, ... }:
{
  services.n8n = {
    enable = true;

    environment = {
      N8N_RUNNERS_AUTH_TOKEN_FILE = config.sops.secrets."n8n_runners_auth_token".path;
    };

    taskRunners.enable = true;
  };

  services.nginx.virtualHosts."n8n.${config.networking.fqdn}" = {
    locations."/" = {
      proxyPass = "http://localhost:5678";
      proxyWebsockets = true;
    };
  };

  nixpkgs.config.allowUnfreePackages = [
    "n8n"
    "n8n-task-runner-launcher"
  ];

  sops.secrets."n8n_runners_auth_token" = { };
}
