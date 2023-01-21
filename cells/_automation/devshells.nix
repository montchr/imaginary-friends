# SPDX-FileCopyrightText: 2022-2023 Chris Montgomery <chris@cdom.io>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs std;
  inherit (inputs.nix-eval-jobs.packages) nix-eval-jobs;
  inherit (inputs.cells) lib presets;
  l = inputs.nixpkgs.lib // builtins;
  name = "Your Imaginary Friends";
  cats = cell.devshellCategories;
in
  l.mapAttrs (_: std.lib.dev.mkShell) {
    default = {...}: {
      inherit name;
      nixago = [
        (lib.nixago.garnix {
          configData = {
            builds.include = [
              "*.x86_64-linux.*"
            ];
          };
        })

        (presets.nixago.commitlint {})
        (presets.nixago.lefthook {})
        (presets.nixago.prettier {})
        (presets.nixago.treefmt {})

        (presets.nixago.statix {
          configData = {
            disabled = ["useless_parens"];
          };
        })
      ];
      packages = [
        nixpkgs.deadnix
        nixpkgs.gh
        nixpkgs.reuse
        nixpkgs.statix
        nixpkgs.treefmt
      ];
      commands = [
        {
          package = nixpkgs.reuse;
          category = cats.legal;
        }
        {
          package = nixpkgs.just;
          category = cats.general;
        }
      ];
      imports = [std.std.devshellProfiles.default];
    };
    ci = {
      packages = [nix-eval-jobs];
      env = [
        {
          name = "NIX_CONFIG";
          value = cell.compat.configCompat;
        }
      ];
    };
  }
