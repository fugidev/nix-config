{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "config.local" ]; # stateful extra config

    settings = {
      "*" = {
        ServerAliveInterval = 240;
      };
      "cleric" = {
        HostName = "cleric.fugi.dev";
        User = "root";
      };
      "librarian" = {
        HostName = "librarian.fugi.dev";
        User = "root";
      };
      "magmacube" = {
        HostName = "192.168.0.2";
        User = "fugi";
      };
      "shepherd" = {
        HostName = "shepherd.fugi.dev";
        User = "root";
      };
      # ifsr
      "quitte" = {
        HostName = "quitte.ifsr.de";
        User = "root";
      };
    };
  };
}
