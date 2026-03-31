{ ... }:
{
  programs.git = {
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519.pub";
    };
    settings = {
      user = {
        name = "Lyn";
        email = "me@fugi.dev";
      };
      commit.gpgSign = true;
    };
  };
}
