{ config, lib, flakeRoot, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (flakeRoot + /modules/initrd-ssh.nix)
  ];

  boot = {
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    kernelParams = [ "ip=${config.fugi.staticIPv4.address}::::${config.networking.hostName}:eno1:off" ];

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ehci_pci"
        "ahci"
        "usb_storage"
        "uas"
        "sd_mod"
        "sdhci_pci"
        "e1000e" # network support for unlocking via ssh
      ];
      kernelModules = [ "dm-snapshot" ];

      luks.devices."crypt-nixos" = {
        device = "/dev/disk/by-uuid/850e280a-dc70-496f-a690-66b7750a575e";
        allowDiscards = true;
      };
    };

    swraid = {
      enable = true;
      mdadmConf = ''
        MAILADDR root

        # mdadm --detail --scan
        ARRAY /dev/md/LibrarianRAID1 metadata=1.2 UUID=fed2c4ff:85b6bb67:598e277f:8e93972d
      '';
    };
  };

  environment.etc.crypttab.text = ''
    crypt-data /dev/md/LibrarianRAID1 /root/data-luks-key luks,nofail
  '';

  fileSystems = {
    "/" = {
      device = "/dev/volume/nixos";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" "x-systemd.device-timeout=0" ];
    };

    "/nix" = {
      device = "/dev/volume/nixos";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

    "/var/log" = {
      device = "/dev/volume/nixos";
      fsType = "btrfs";
      options = [ "subvol=log" "compress=zstd" "noatime" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/6EBD-0C45";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    "/data" = {
      device = "/dev/mapper/crypt-data";
      fsType = "btrfs";
      options = [ "compress=zstd" "noatime" "nofail" ];
    };
  };

  swapDevices = [{
    device = "/dev/volume/swap";
  }];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
