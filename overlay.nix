_: prev:
let
  dirPathsNamed = import ./util/dirPathsNamed.nix;
  pkgs = builtins.mapAttrs (name: path: prev.callPackage path { }) (dirPathsNamed ./pkgs);
in
pkgs
// {
  php82 = prev.php82.overrideAttrs {
    version = "8.2.35";
    hash = "sha256-D0Pv0awk1PkAAsjU1XC/TE1Z+hQxO/JwqujPBNnf3vM=";
  };
  php83 = prev.php83.overrideAttrs {
    version = "8.3.36";
    hash = "sha256-RvS0XjaI7SsYGQFae1MsFbUcwFW907E/0A3f7r7tzV8=";
  };
  php84 = prev.php84.overrideAttrs {
    version = "8.4.27";
    hash = "sha256-slMKh3xyL0sIyeF0owywi6wrfhkD7m6eMV8KqfX4LCQ=";
  };
  php85 = prev.php85.overrideAttrs {
    version = "8.5.12";
    hash = "sha256-/7YO3EN87WO1E35JhNs3moERxQBJxxFRDYuVgnfvwag=";
  };
  php86 = prev.php86.overrideAttrs {
    knownVulnerabilities = [
      "CVE-2026-109619"
      "CVE-2026-109618"
    ];
  };
}
