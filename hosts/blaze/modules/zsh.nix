{ lib, ... }:
{
  fugi.promptColor = "#f7ce46"; # yellow

  programs.zsh = {
    shellAliases = {
      rebuild = lib.mkForce "nixos-rebuild --log-format multiline --impure --use-remote-sudo";
      rebuild-shepherd = "nixos-rebuild --log-format multiline --target-host shepherd --flake .#shepherd";
    };
  };
}
