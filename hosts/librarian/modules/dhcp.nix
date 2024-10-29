{ flakeRoot, ... }:
{
  imports = [
    (flakeRoot + /modules/dhcp.nix)
  ];

  fugi.dhcp4 = {
    interface = "eno1";
    pool = "192.168.0.101 - 192.168.0.160";
  };
}
