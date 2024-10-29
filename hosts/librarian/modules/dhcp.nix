{ flakeRoot, ... }:
{
  imports = [
    (flakeRoot + /modules/dhcp.nix)
  ];

  fugi.dhcp = {
    interface = "eno1";
    IPv4Pool = "192.168.0.101 - 192.168.0.160";
  };
}
