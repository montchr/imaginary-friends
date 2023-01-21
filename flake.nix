# SPDX-FileCopyrightText: 2022-2023 Chris Montgomery <chris@cdom.io>
# SPDX-License-Identifier: GPL-3.0-or-later
{
  description = "say hello to my invisible friends";

  inputs.nixos.url = "nixpkgs/nixos-unstable";
  inputs.nixpkgs.follows = "nixos";

  inputs.flake-registry.url = "github:NixOS/flake-registry";
  inputs.flake-registry.flake = false;

  inputs.std.url = "github:divnix/std";
  inputs.std.inputs.nixpkgs.follows = "nixpkgs";
  inputs.dmerge.follows = "std/dmerge";

  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.colmena.url = "github:zhaofengli/colmena";
  inputs.colmena.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nix-eval-jobs.url = "github:nix-community/nix-eval-jobs/v2.11.0";
  inputs.nixos-generators.url = "github:nix-community/nixos-generators";

  outputs = {
    std,
    self,
    ...
  } @ inputs: let
    inherit (std) blockTypes growOn harvest;
    system = builtins.currentSystem or "aarch64-darwin";
  in
    growOn {
      inherit inputs;
      cellsFrom = ./cells;
      cellBlocks = [
        (blockTypes.data "profiles")
        (blockTypes.data "modules")

        (blockTypes.data "hosts")
        (blockTypes.data "nodes")
        (blockTypes.data "homes")

        (blockTypes.data "compat")
        (blockTypes.data "sources")

        (blockTypes.functions "lib")

        ##: --- public ---

        #: lib
        (blockTypes.functions "functions")
        (blockTypes.nixago "nixago")
        (blockTypes.installables "packages")

        #: presets
        (blockTypes.nixago "nixago")

        ##: --- internal ---

        #: _automation
        (blockTypes.devshells "devshells")
        (blockTypes.data "devshellCategories")
        (blockTypes.nixago "nixago")
      ];
    }
    {
      devShells = harvest self ["_automation" "devshells"];
      lib = (std.harvest self ["clusters" "lib"]).${system};
      nixosConfigurations = (std.harvest self ["clusters" "hosts"]).${system};
      packages = harvest self [["_automation" "packages"]];
    };

  nixConfig = {
    # post-build-hook = ./comb/ops/upload-to-cache.sh;
    allow-import-from-derivation = false;
    extra-experimental-features = "nix-command flakes";
    extra-substituters = [
      "https://dotfield.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "dotfield.cachix.org-1:b5H/ucY/9PDARWG9uWA87ZKWUBU+hnfF30amwiXiaNk="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
