{ flakeRoot, ... }:
{
  imports = [
    (flakeRoot + /modules/borg.nix)
  ];

  fugi.borgRepositories = [{
    path = "ssh://u329990-sub5@u329990-sub5.your-storagebox.de:23/./borg-repository";
    label = "storagebox";
  }];
}
