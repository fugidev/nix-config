{ config, pkgs, ... }:
{
  time.timeZone = "Europe/Berlin";

  users.users.root.openssh.authorizedKeys.keys = config.fugi.authorizedKeys;

  environment.systemPackages = with pkgs; [
    helix
    git
    fd
    exa
    ripgrep
    wget
    doggo
  ];

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
