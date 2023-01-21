# SPDX-FileCopyrightText: 2022-2023 Chris Montgomery <chris@cdom.io>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  inputs,
  cell,
}: let
  l = inputs.nixpkgs.lib // builtins;
  inherit (inputs.cells.clusters) hosts;
in {
  generate-base-ami = inputs.nixos-generators.nixosGenerate {
    system = "aarch64-linux";
    modules = [hosts.freundix];
    format = "amazon";
  };
}
