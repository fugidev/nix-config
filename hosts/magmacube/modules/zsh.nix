{ ... }:
{
  programs.zsh = {
    shellAliases = {
      rebuild = "nixos-rebuild --log-format multiline --use-remote-sudo";
      rebuild-librarian = "nixos-rebuild --log-format multiline --target-host librarian --flake .#librarian";
    };
  };
}
