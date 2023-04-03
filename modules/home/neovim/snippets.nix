{ lib, pkgs }:
let
  mkSnippet = prefix: description: body: mkSnippet' prefix description body { };
  mkSnippet' = prefix: description: body: { autotrigger ? false }: {
    inherit prefix description body;
    luasnip = {
      inherit autotrigger;
    };
  };

  snippets = {
    nix = {
      Module = mkSnippet "mod" "NixOS Module" "{ config, lib, pkgs, ... }:\n{\n\n}";
    };
  };

  snippetsIndex = pkgs.writeTextDir "package.json" (builtins.toJSON {
    contributes.snippets = lib.mapAttrs
      (id: language: { inherit language; path = "./snippets/${id}.json"; })
      {
        nix = [ "nix" ];
        rust = [ "rust" ];
      };
  });

  snippetsDir = pkgs.symlinkJoin {
    name = "luasnip-snippets";
    paths = (lib.mapAttrsToList
      (ft: content: pkgs.writeTextDir "snippets/${ft}.json" (builtins.toJSON content))
      snippets) ++ (lib.singleton snippetsIndex);
  };
in
pkgs.writeText "snippets.lua" ''
  require("luasnip/loaders/from_vscode").load({ paths = { '${snippetsDir}' } })

  require("luasnip/loaders/from_vscode").lazy_load() -- other snippets
''

