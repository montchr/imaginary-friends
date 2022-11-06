{
  inputs,
  cell,
}: let
  inherit (inputs) cells;
  inherit (cells) enzymes;
in {
  freundix = enzymes.incarnate {
    system = "aarch64-linux";
    profiles = [
      ./freundix
    ];
  };
}
