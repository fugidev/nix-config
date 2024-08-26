# for some reason, importing does not work without `pkgs` here, even if it is not used in this file
{ pkgs, ... }@args:
let
  nixosLocaleConfig = import ../locale.nix args;
in
{
  i18n = {
    glibcLocales = nixosLocaleConfig.i18n.glibcLocales.override {
      locales = [
        "C.UTF-8/UTF-8"
        "en_US.UTF-8/UTF-8"
        "en_SE.UTF-8/UTF-8"
      ];
    };
  };
}
