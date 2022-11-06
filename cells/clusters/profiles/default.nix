{
  inputs,
  cell,
}: let
  l = inputs.nixpkgs.lib // builtins;
in {
  inherit inputs;
  nix = {
    imports = [
      ./nix.nix
    ];

    nix = {
      registry = let
        sansNixpkgs = l.removeAttrs inputs ["nixpkgs" "cells" "self" "std"];
      in
        l.mapAttrs
        (_: flake: {inherit flake;})
        sansNixpkgs;
      nixPath = ["home-manager=${inputs.home-manager}"];
      settings.flake-registry = "${inputs.flake-registry}/flake-registry.json";
    };
  };

  home-manager = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];
  };
}
