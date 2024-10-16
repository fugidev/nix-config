{ machineConfig, ... }:
{
  networking.networkmanager = {
    enable = true;
    ensureProfiles.profiles = {
      "wired" = {
        connection = {
          id = "wired";
          uuid = "39acc39f-4c2b-3502-bbc6-39335ea57758";
          interface-name = "enp5s0";
          type = "ethernet";
        };
        ethernet = { };
        ipv4 = {
          addresses = machineConfig.IPv4.cidr;
          gateway = "192.168.0.1";
          method = "manual";
        };
        ipv6 = {
          addresses = machineConfig.IPv6.cidr;
          addr-gen-mode = "stable-privacy";
          method = "auto";
        };
      };
    };
  };

  programs.nm-applet.enable = true;
}
