{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./modules/libreddit.nix
    ./modules/nginx
    ./modules/roundcube.nix
    ./modules/searx.nix
    ./modules/thelounge.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
    default = "saved";
    extraEntries = ''
      menuentry "NixOS Nitwit (quitte test)" {
        search --set=myroot --fs-uuid 715908e3-f317-4f8f-8bd3-1ca0619cd9c6
        configfile "($myroot)/boot/grub/grub.cfg"
      }
    '';
  };

  networking = {
    hostName = "nitwit";
    interfaces.ens3.ipv4.addresses = [{
      address = "178.254.28.214";
      prefixLength = 22;
    }];
    defaultGateway = "178.254.28.1";
    nameservers = [ "178.254.16.151" "178.254.16.141" ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # user configuration
  users.users.root.openssh.authorizedKeys.keys = config.fugi.authorizedKeys;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

