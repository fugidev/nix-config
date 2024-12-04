{ config, lib, ... }:
let
  port = 51820;
  networkd-user = config.users.users.systemd-network.name;

  peers = {
    magmacube = {
      ip = "10.13.13.2";
      pubkey = "ufquWDlrYlwL6q7k5jPhdnBcXbafTj3q2ZN58bS6LUk=";
    };
    blaze = {
      ip = "10.13.13.3";
      pubkey = "hF7A7u7MNApjplB5YkEyaso1ofe6J+wNebvOYL29W04=";
    };
    iphone = {
      ip = "10.13.13.4";
      pubkey = "K5Z293wcol7NpFGPgvk0FARugdcvlIR24pO93R0PzBc=";
    };
    ipad = {
      ip = "10.13.13.6";
      pubkey = "tKZti1axquOBGc/Tpfa+WwQ3FsU05lj1E+7v2Pbu9nU=";
    };
    librarian = {
      ip = "10.13.13.7";
      pubkey = "0lTX7rPiyX0bEklHtqkfBvjz6MO9J7cv0t26Rw7bwEQ=";
    };
    shepherd = {
      ip = "10.13.13.8";
      pubkey = "+UUnliDhfDxgy4Xof2UISeCboyKnl6Os7uWfzjBSyhA=";
    };
    hl = {
      ip = "10.13.13.9";
      pubkey = "E6PSt6wehfrx3MbwXdOa64194epQ0UDFxjm7YNAygyU=";
    };
    oldcleric = {
      ip = "10.13.13.10";
      pubkey = "YIGsHSRB0p3JDMTxlLGNd85h8seO192/LOwIfyymfD4=";
    };
  };
in
{
  sops.secrets = {
    "wireguard/privkey".owner = networkd-user;
  } // (
    lib.concatMapAttrs
      (name: _: {
        "wireguard/psk-${name}".owner = networkd-user;
      })
      peers
  );

  networking.firewall.allowedUDPPorts = [ port ];

  systemd.network = {
    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
        MTUBytes = "1300";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."wireguard/privkey".path;
        ListenPort = port;
        RouteTable = "main";
      };
      wireguardPeers = lib.mapAttrsToList
        (name: peer: {
          PublicKey = peer.pubkey;
          AllowedIPs = [ "${peer.ip}/32" ];
          PresharedKeyFile = config.sops.secrets."wireguard/psk-${name}".path;
        })
        peers;
    };
    networks.wg0 = {
      matchConfig.Name = "wg0";
      address = ["10.13.13.1/24"];
      networkConfig = {
        IPMasquerade = "ipv4";
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };
    };
  };
}
