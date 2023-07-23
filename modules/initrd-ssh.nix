# Find the required kernel module for the network adapter using `lspci -v` and add it to `boot.initrd.availableKernelModules`.
# Enable `networking.useDHCP` or set a static ip using the `ip=` kernel parameter.
# Generate another SSH host key for the machine:
# $ ssh-keygen -t ed25519 -N "" -f /etc/ssh/ssh_host_ed25519_key_initrd -C HOSTNAME-initrd
# Add the public key to your known_hosts and create an ssh config entry.
{ config, ... }:
{
  boot.initrd.network = {
    enable = true;
    ssh = {
      inherit (config.fugi) authorizedKeys;

      enable = true;
      port = 222;
      shell = "/bin/cryptsetup-askpass";
      hostKeys = [ "/etc/ssh/ssh_host_ed25519_key_initrd" ];
    };
  };
}
