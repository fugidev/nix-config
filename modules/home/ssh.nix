{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "config.local" ]; # stateful extra config

    matchBlocks = {
      "*" = {
        serverAliveInterval = 240;
      };
      "cleric" = {
        hostname = "cleric.fugi.dev";
        user = "root";
      };
      "librarian" = {
        hostname = "librarian.fugi.dev";
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
      # ifsr
      "quitte" = {
        hostname = "quitte.ifsr.de";
        user = "root";
      };
    };
  };
}
