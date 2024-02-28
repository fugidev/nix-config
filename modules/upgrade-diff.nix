{ pkgs, ... }: {
  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = ''
      ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"

      NO_FORMAT="\033[0m"
      F_BOLD="\033[1m"
      C_RED="\033[38;5;9m"

      ${pkgs.diffutils}/bin/cmp --silent \
        <(readlink /run/booted-system/{initrd,kernel,kernel-modules}) \
        <(readlink /run/current-system/{initrd,kernel,kernel-modules}) \
        || echo -e "''${F_BOLD}''${C_RED}Kernel version changed, reboot is advised.''${NO_FORMAT}"
    '';
  };
}
