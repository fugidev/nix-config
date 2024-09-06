{ lib, flakeRoot, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (flakeRoot + /modules/initrd-ssh.nix)
  ];

  boot = {
    kernelModules = [ ];
    extraModulePackages = [ ];

    initrd = {
      availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "virtio_pci"
        "sr_mod"
        "virtio_blk"
      ];
      kernelModules = [ "dm-snapshot" ];

      luks.devices."crypt".device = "/dev/disk/by-uuid/25f48b5d-71b5-40ed-b01c-0f2da508d634";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/35d03db4-c452-4e17-98c1-063314cce6e7";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/35d03db4-c452-4e17-98c1-063314cce6e7";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/6502-3482";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/b6430b2f-ebf8-4231-894d-b5b753fb9685";
  }];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
