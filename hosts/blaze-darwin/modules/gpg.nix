{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnupg
    pinentry_mac
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # disable saving passwords to keychain
  system.defaults.CustomUserPreferences = {
    "org.gpgtools.common" = {
      "UseKeychain" = "NO";
      "DisableKeychain" = "yes";
    };
  };

  home-manager.users.fugi.home.file.".gnupg/gpg-agent.conf".text = ''
    pinentry-program /run/current-system/sw/bin/pinentry-mac
  '';
}
