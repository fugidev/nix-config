{ config, inputs, ... }:
{
  imports = [
    (inputs.iceshrimp-notifs + /module.nix)
  ];

  sops.secrets.iceshrimp-notifs-env = { };

  services.iceshrimp-notifs = {
    enable = true;
    environmentFile = config.sops.secrets.iceshrimp-notifs-env.path;
  };
}
