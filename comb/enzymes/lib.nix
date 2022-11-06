{inputs, cell}: 
let 
inherit (inputs) nixpkgs dm;
pkgs' = nixpkgs.legacyPackages;
l = nixpkgs.lib // builtins;
in
{
  incarnate = {
    system ? pkgs'.system,
    profiles ? [],
    recursiveProfiles ? config: [],
  }:
  l.nixosSystem {
    inherit system;
    modules = [cell.profiles.nix] ++ profiles;
  };

  mergeAll = l.foldl' dm.merge {};

}
