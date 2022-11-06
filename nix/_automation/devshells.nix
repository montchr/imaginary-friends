{
  inputs,
  cell,
}: let
  inherit (inputs.std) std lib;

  l = nixpkgs.lib // builtins;
  dev = lib.dev.mkShell {
    packages = [
      nixpkgs.pkg-config
    ];
    env = [ ];
    imports = [ ];

    commands = let
    in
      [
        {
          package = nixpkgs.treefmt;
          category = "repo tools";
        }
        {
          package = nixpkgs.alejandra;
          category = "repo tools";
        }
        {
          package = std.cli.default;
          category = "std";
        }
      ];
  };
in {
  inherit dev;
  default = dev;
}
