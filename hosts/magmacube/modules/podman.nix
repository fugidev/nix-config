{ pkgs, ... }:
{
  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = with pkgs; [ podman-compose ];

  users.users.fugi.extraGroups = [ "podman" ];
}
