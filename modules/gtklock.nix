# tmp until upstreamed

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.gtklock;

  # finalPackage = pkgs.symlinkJoin {
  #   inherit (cfg.package) version;
  #   pname = "gtklock-wrapped";
  #   paths = [ cfg.package ] ++ cfg.modules;
  # };
in
{
  options.programs.gtklock =
    let
      inherit (lib)
        types
        mkOption
        mkEnableOption
        mkPackageOption
        ;
    in
    {
      enable = mkEnableOption "gtklock";

      package = mkPackageOption pkgs "gtklock" { };

      config = mkOption {
        type = types.submodule {
          freeformType = with types; attrsOf (oneOf [str path bool int]);
        };
      };

      style = mkOption {
        type = with types; nullOr str;
        default = null;
      };

      modules = mkOption {
        type = with types; listOf package;
        default = [ ];
      };
    };

  config = lib.mkIf cfg.enable {
    programs.gtklock.config = {
      style = lib.mkIf (cfg.style != null) (pkgs.writeText "style.css" cfg.style);

      modules = lib.mkIf (cfg.modules != [ ]) (
        lib.concatMapStringsSep ";" (
          pkg: "${pkg}/lib/gtklock/${lib.removePrefix "gtklock-" pkg.pname}.so"
        ) cfg.modules
      );
    };

    environment.etc."xdg/gtklock/config.ini".text = lib.generators.toINI { } { main = cfg.config; };

    environment.systemPackages = [ cfg.package ];

    security.pam.services.gtklock = { };
  };
}
