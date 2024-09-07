{ config, lib, machineConfig, ... }:
let
  enginesToList = lib.mapAttrsToList (name: value: value // { inherit name; });
in
{
  sops.secrets."searx-env-file" = { };

  services.searx = {
    enable = true;
    redisCreateLocally = true;
    runInUwsgi = true;
    uwsgiConfig = {
      disable-logging = true;
      http = "127.0.0.1:8198";
    };
    environmentFile = config.sops.secrets."searx-env-file".path;
    settings = {
      server = {
        secret_key = "@SEARXNG_SECRET@";
        limiter = true;
        public_instance = true;
        method = "GET";
      };
      ui = {
        infinite_scroll = true;
      };
      use_default_settings.engines.keep_only = [
        "arch linux wiki"
        "bing"
        "bing images"
        "bing news"
        "ccc-tv"
        "currency"
        "duckduckgo"
        "google"
        "google images"
        "google news"
        "google videos"
        "lemmy communities"
        "lemmy users"
        "lemmy posts"
        "lemmy comments"
        "mdn"
        "qwant"
        "qwant images"
        "qwant news"
        "wikidata"
        "wikipedia"
        "wiktionary"
        "yahoo news"
      ];
      engines = enginesToList {
        "arch linux wiki".shortcut = "aw";
        wikipedia.shortcut = "w";
        bing = {
          shortcut = "b";
          disabled = false;
        };
        "bing images".shortcut = "bi";
        "ccc-tv".disabled = false;
        google.shortcut = "g";
        "google images".shortcut = "gi";
        "google news".shortcut = "gn";
        "google videos".shortcut = "gv";
      };
    };
  };

  services.nginx.virtualHosts."searx.${machineConfig.baseDomain}" = {
    locations."/".proxyPass = "http://${config.services.searx.uwsgiConfig.http}";
  };
}
