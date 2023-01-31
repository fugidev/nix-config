{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "librarian";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0X6L7NwTHiOmFzo8mJBCy6H+DKUePAAXU4amm32DAQ fugi@magmacube"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHD1ZkrAmC9g5eJPDgv4zuEM+UIIEWromDzM1ltHt4TM fugi@blaze"
  ];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [ ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}

