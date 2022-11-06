{
  inputs,
  cell,
}: {
  configCompat = let
    inherit (import "${inputs.self}/flake.nix") nixConfig;
    compatFunc = inputs.nixpkgs.callPackage ./nix.conf.nix {};
  in
    compatFunc nixConfig;
}
