{ pkgs, lib, util, ... }:
{
  imports = [
    (util.useFromUnstable {
      pkgs = [ "nixfmt" ];
    })
  ];

  environment.systemPackages =
    with pkgs;
    [
      ## very essential
      fastfetch
      hyfetch
      ## system utilities
      btop
      duf
      eza
      fd
      file
      htop
      jq
      ncdu
      pv
      ripgrep
      unzip
      xxd
      ## network utilities
      curl
      dig
      doggo
      nmap
      wget
      ## vcs / code
      git
      helix
      nixfmt
      nix-output-monitor
      tig
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      gptfdisk
      pciutils
      psmisc
      smartmontools
      traceroute
      usbutils
      xdg-utils
    ];
}
