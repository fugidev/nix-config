{ flakeRoot, ... }:
{
  imports = [
    (flakeRoot + /modules/dhcp.nix)
  ];

  fugi.dhcp = {
    interface = "end0";
    IPv4Pool = "192.168.0.161 - 192.168.0.220";
  };
}
