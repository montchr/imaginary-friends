# SPDX-FileCopyrightText: 2022-2023 Chris Montgomery <chris@cdom.io>
# SPDX-License-Identifier: GPL-3.0-or-later
{
  inputs,
  cell,
}: let
  inherit (inputs.cells) lib;
in {
  garnix = lib.nixago.garnix {
    configData = {
      builds.include = [
        "*.x86_64-linux.*"
        "devShells.*.ci"
      ];
      builds.exclude = [
        "devShells.*.default"
      ];
    };
  };
}
