{ lib, pkgs, ... }:
{
  programs.sftpman.package = pkgs.sftpman-python.override {
    mountPath = "/Users/fugi/.cache/sshfs/";
  };

  programs.zsh.initContent = lib.mkAfter ''
    # Disable git integration in ~/.cache/sshfs
    zstyle ':vcs_info:*' disable-patterns "~/.cache/sshfs(|/*)"
  '';
}
