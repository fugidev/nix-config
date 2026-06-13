{ lib, pkgs, ... }:
{
  programs.sftpman.package = pkgs.sftpman-python.override {
    mountPath = "/Users/lyn/.cache/sshfs/";
  };

  programs.zsh.initContent = lib.mkAfter ''
    # Disable git integration in ~/.cache/sshfs
    zstyle ':vcs_info:*' disable-patterns "~/.cache/sshfs(|/*)"
  '';
}
