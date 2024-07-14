{ config, pkgs, ... }:
{
  time.timeZone = "Europe/Berlin";

  users.users.root.openssh.authorizedKeys.keys = config.fugi.authorizedKeys;

  environment.systemPackages = with pkgs; [
    helix
    git
    fd
    eza
    ripgrep
    wget
    doggo
  ];

  ## nitwit
  # networking = {
  #   interfaces.ens3.ipv4.addresses = [{
  #     address = "178.254.28.214";
  #     prefixLength = 22;
  #   }];
  #   defaultGateway = {
  #     address = "178.254.28.1";
  #     interface = "ens3";
  #   };
  #   nameservers = [
  #     "178.254.16.151"
  #     "178.254.16.141"
  #   ];
  # };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
