# SPDX-FileCopyrightText: 2022-2023 Chris Montgomery <chris@cdom.io>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs dm;
  pkgs' = nixpkgs;
  l = nixpkgs.lib // builtins;
in {
  incarnate = {
    system ? pkgs'.system,
    profiles ? [],
    recursiveProfiles ? config: [],
  }:
    inputs.nixos.lib.nixosSystem {
      inherit system;
      modules = [cell.profiles.nix] ++ profiles;
    };

  mergeAll = l.foldl' dm.merge {};
}
