{ config, lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];

    initrd = {
      systemd.enable = true;
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ "dm-snapshot" ];

      luks.devices."crypt".device = "/dev/disk/by-uuid/854ea552-cac9-485e-86c2-bd601833fdd8";
    };
  };

  environment.etc.crypttab.text = ''
    crypt-games UUID=5019e6d8-de45-41c1-ad6d-81466c528747 - luks,nofail
  '';

  fileSystems = {
    "/" = {
      device = "/dev/mapper/magmacube-root";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" "noatime" "x-systemd.device-timeout=0" ];
    };

    "/nix" = {
      device = "/dev/mapper/magmacube-root";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd" "noatime" ];
    };

    "/home" = {
      device = "/dev/mapper/magmacube-root";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" "noatime" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/B8F6-13E2";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    "/media/games" = {
      device = "/dev/mapper/crypt-games";
      fsType = "btrfs";
      options = [ "subvol=@games" "compress=zstd" "noatime" "nofail" ];
    };
  };

  swapDevices = [{
    device = "/dev/mapper/magmacube-swap";
  }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
