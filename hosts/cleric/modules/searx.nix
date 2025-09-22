{ config, lib, machineConfig, ... }:
let
  enginesToList = lib.mapAttrsToList (name: value: value // { inherit name; });
  fqdn = "searx.${machineConfig.baseDomain}";
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
        method = "GET";
      };
      ui = {
        infinite_scroll = true;
      };
      use_default_settings.engines.keep_only = [
        "arch linux wiki"
        "ccc-tv"
        "currency"
        "duckduckgo"
        "google"
        "google images"
        "google news"
        "google videos"
        "mdn"
        "wikidata"
        "wikipedia"
        "wiktionary"
      ];
      engines = enginesToList {
        "arch linux wiki".shortcut = "aw";
        "wikipedia".shortcut = "w";
        "bing images".shortcut = "bi";
        "ccc-tv".disabled = false;
        "google".shortcut = "g";
        "google images".shortcut = "gi";
        "google news".shortcut = "gn";
        "google videos".shortcut = "gv";
      };
    };
    limiterSettings = {
      # this seems to break using it as browser default search engine... wtf
      "botdetection.ip_limit".link_token = false;
    };
  };

  services.nginx = {
    commonHttpConfig = ''
      log_format no_query '$remote_addr - $remote_user [$time_local] '
        '"$request_method $uri" $status $body_bytes_sent '
        '"$http_referer" "$http_user_agent"';
    '';
    virtualHosts.${fqdn} = {
      extraConfig = lib.mkForce ''
        access_log /var/log/nginx/${fqdn}_access.log no_query;
        error_log /var/log/nginx/${fqdn}_error.log;
      '';
      locations."/".proxyPass = "http://${config.services.searx.uwsgiConfig.http}";
    };
  };
}
