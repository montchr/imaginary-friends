{
  inputs,
  cell,
}: let
  inherit (inputs) cells;
  inherit (cell) lib;
in {
  freundix = lib.incarnate {
    system = "aarch64-linux";
    profiles = [
      ./freundix
    ];
  };
}
