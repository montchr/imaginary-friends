{
  description = "say hello to my invisible friends";

  inputs.std.url = "github:divnix/std";
  inputs.std.inputs.nixpkgs.follows = "nixpkgs";

  outputs = inputs @ {
    self,
    std,
    ...
  }:
    std.growOn {
      inherit inputs;
      systems = ["aarch64-darwin" "aarch64-linux"];
      cellsFrom = ./nix;
      cellBlocks = [
        (std.devshells "devshells")
        (std.installables "packages")
      ];
    } {
      devShells = std.harvest self ["_automation" "devshells"];
      # packages = std.harvest self ["hello" "packages"];
    };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
