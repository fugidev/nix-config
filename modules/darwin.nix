{ ... }:
{
  imports = [
    ./lix.nix # use lesbiab nix
  ];

  nix.settings = {
    sandbox = true;
    experimental-features = "nix-command flakes";
  };
}
