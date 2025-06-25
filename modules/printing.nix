{ ... }:
{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;

    # actually *breaks* IPP Everywhere printers
    browsed.enable = false;
  };
}
