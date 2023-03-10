{ config, lib, pkgs, ... }:
let
  heikoDriver = "Kyocera ECOSYS M6630cidn.ppd";
in
{
  services = {
    avahi.enable = true;
    avahi.nssmdns = true;
    avahi.openFirewall = true;

    printing.enable = true;
    printing.drivers = [
      (pkgs.writeTextDir ("share/cups/model/" + heikoDriver) (builtins.readFile ../misc/${heikoDriver}))
    ];
  };

  hardware.printers.ensurePrinters = [{
    name = "Heiko";
    description = "Drucker im FSR Buero";
    deviceUri = "dnssd://Kyocera%20ECOSYS%20M6630cidn._ipp._tcp.local/?uuid=4509a320-007e-002c-00dd-002507504ad0";
    location = "FSR Buero";
    model = heikoDriver;
  }];
}
