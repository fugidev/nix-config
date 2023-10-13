{ config, lib, pkgs, ... }:
let
  withExecZsh = host: host // {
    extraOptions = {
      "RemoteCommand" = "exec zsh";
      "RequestTTY" = "yes";
    };
  };
in
{
  programs.ssh = {
    enable = true;
    serverAliveInterval = 240;
    includes = [ "config.local" ]; # stateful extra config

    matchBlocks = rec {
      "cleric" = {
        hostname = "cleric.fugi.dev";
        port = 2122;
        user = "root";
      };
      "nitwit" = {
        hostname = "nitwit.fugi.dev";
        user = "root";
      };
      "librarian" = {
        hostname = "librarian.fugi.dev";
        user = "root";
      };
      "librarian-initrd" = {
        hostname = "192.168.0.3";
        port = 222;
        user = "root";
      };
      "magmacube" = {
        hostname = "192.168.0.2";
        user = "fugi";
        proxyJump = "fugi@librarian";
      };
      # ifsr
      "quitte" = withExecZsh quitte_;
      "kaki" = withExecZsh kaki_;
      "quitte_" = {
        hostname = "quitte.ifsr.de";
        user = "root";
      };
      "kaki_" = {
        hostname = "kaki.ifsr.de";
        user = "root";
      };
      "durian" = {
        hostname = "durian.ifsr.de";
        user = "root";
        setEnv = {
          TERM = "xterm-256color";
        };
      };
    };
  };
}
