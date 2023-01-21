# SPDX-FileCopyrightText: 2022-2023 Chris Montgomery <chris@cdom.io>
#
# SPDX-License-Identifier: GPL-3.0-or-later
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
