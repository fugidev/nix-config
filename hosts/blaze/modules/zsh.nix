{ ... }:
{
  programs.zsh = {
    shellAliases = {
      rebuild = "sudo nixos-rebuild --log-format multiline --impure";
      rebuild-shepherd = "nixos-rebuild --log-format multiline --target-host shepherd --flake .#shepherd";
    };
  };
}
