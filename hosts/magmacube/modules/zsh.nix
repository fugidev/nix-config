{ ... }:
{
  fugi.promptColor = "#ff8700"; # orange

  programs.zsh = {
    shellAliases = {
      rebuild-librarian = "nixos-rebuild --log-format multiline --target-host librarian --flake .#librarian";
    };
  };
}
