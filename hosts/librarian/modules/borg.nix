{ flakeRoot, ... }:
{
  imports = [
    (flakeRoot + /modules/borg.nix)
  ];

  fugi.borgRepositories = [{
    path = "ssh://u329990-sub1@u329990-sub1.your-storagebox.de:23/./borg-repository";
    label = "storagebox";
  }];
}
