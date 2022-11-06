{
  inputs,
  cell,
}: let
  inherit (inputs) std;
  inherit (inputs.nix-eval-jobs.packages) nix-eval-jobs;
  l = inputs.nixpkgs.lib // builtins;
  pkgs' = inputs.nixpkgs;
in
  l.mapAttrs (_: std.lib.dev.mkShell) rec {
    ci = {
      packages = [nix-eval-jobs];
      env = [
        {
          name = "NIX_CONFIG";
          value = cell.compat.configCompat;
        }
      ];
    };
    default = {...}: {
      name = "Your Imaginary Friends";
      imports = [std.std.devshellProfiles.default];
      nixago = [
        # (std.nixago.conform {configData = {inherit (inputs) cells;};})
        # cell.nixago.treefmt
        # cell.nixago.editorconfig
        # cell.nixago.just
        # std.nixago.lefthook
        # std.nixago.adrgen
      ];
      commands =
        [
          {
            package = pkgs'.reuse;
            category = "legal";
          }
          {
            package = pkgs'.alejandra;
            category = "tools";
          }
          {
            package = pkgs'.treefmt;
            category = "tools";
          }
        ]
        ++ l.optionals pkgs'.stdenv.isLinux [];
    };

    # checks = {...}: {
    #   name = "checks";
    #   imports = [std.devshellProfiles.default];
    #   commands = [];
    # };
  }
