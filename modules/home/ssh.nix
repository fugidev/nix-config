{
  programs.ssh = {
    enable = true;
    serverAliveInterval = 240;
    includes = [ "config.local" ]; # stateful extra config

    matchBlocks = {
      "cleric" = {
        hostname = "cleric.fugi.dev";
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
      };
      "shepherd" = {
        hostname = "shepherd.fugi.dev";
        user = "root";
      };
      "oldcleric" = {
        hostname = "fugi.dev";
        port = 2122;
        user = "root";
      };
      # ifsr
      "quitte" = {
        hostname = "quitte.ifsr.de";
        user = "root";
      };
    };
  };
}
