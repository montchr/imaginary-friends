{
  inputs,
  cell,
}: let
  inherit (inputs) cells;
  inherit (cells) lib;
in {
  freundix = lib.incarnate {
    system = "aarch64-linux";
    profiles = [
      ./freundix
    ];
  };
}
