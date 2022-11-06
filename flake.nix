{
  description = "say hello to my invisible friends";

  inputs.nixos.url = "nixpkgs/nixos-unstable";
  inputs.nixpkgs.follows = "nixos";

  inputs.flake-registry.url = "github:NixOS/flake-registry";
  inputs.flake-registry.flake = false;

  inputs.std.url = "github:divnix/std";
  inputs.std.inputs.nixpkgs.follows = "nixpkgs";
  inputs.dm.follows = "std/dmerge";

  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nix-eval-jobs.url = "github:nix-community/nix-eval-jobs/v2.11.0";

  outputs = inputs @ {
    self,
    std,
    nixpkgs,
    ...
  }: let
    system = builtins.currentSystem or "aarch64-darwin";
  in
    std.growOn {
      inherit inputs;
      systems = ["aarch64-darwin" "aarch64-linux"];
      cellsFrom = ./cells;
      cellBlocks = with std.blockTypes; [
        (functions "lib")

        (data "profiles")
        (data "modules")

        (data "hosts")
        (data "nodes")
        (data "homes")

        (data "compat")
        (data "sources")

        (installables "packages")

        (devshells "devshells")
      ];
    } {
      devShells = std.harvest self ["_automation" "devshells"];
      lib = (std.harvest self ["clusters" "lib"]).${system};
      nixosConfigurations = (std.harvest self ["clusters" "hosts"]).${system};
    };

  nixConfig = {
    # post-build-hook = ./comb/ops/upload-to-cache.sh;
    allow-import-from-derivation = false;
    extra-substituters = [
      "https://dotfield.cachix.org"
      "https://iosevka-xtal.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "dotfield.cachix.org-1:b5H/ucY/9PDARWG9uWA87ZKWUBU+hnfF30amwiXiaNk="
      "iosevka-xtal.cachix.org-1:5d7Is01fs3imwU9w5dom2PcSskJNwtJGbfjRxunuOcw="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
