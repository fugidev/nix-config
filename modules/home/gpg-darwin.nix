{ lib, ... }:
{
  # disable saving passwords to keychain
  home.activation = {
    gnupg-disable-keychain = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run /usr/bin/defaults write org.gpgtools.common UseKeychain NO
    '';
  };

  # ssh agent integration
  programs.zsh.initContent = ''
    unset SSH_AGENT_PID
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    export GPG_TTY=$(tty)
    gpg-connect-agent updatestartuptty /bye >/dev/null
  '';
}
