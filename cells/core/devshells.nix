{
  inputs,
  cell,
}: let
  inherit (inputs) std;
  l = inputs.nixpkgs.lib // builtins;
  l' = inputs.cells.lib.functions;
  pkgs' = inputs.nixpkgs;
  cats = l'.enumAttrs [
    "maintenance"
  ];
in
  l.mapAttrs (_: std.lib.dev.mkShell) {
    default = {...}: {
      name = "nix-flake-template";
      nixago = [
        cell.configs.commitlint
        cell.configs.editorconfig
        cell.configs.lefthook
        cell.configs.prettier
        cell.configs.treefmt
      ];
      packages = [
        pkgs'.gh
      ];
      commands = [
        {
          category = cats.maintenance;
          package = pkgs'.reuse;
        }
        {
          name = "fmt";
          command = "treefmt src";
          help = "Formats the project files";
          category = cats.maintenance;
        }
      ];
    };
  }
