# SPDX-FileCopyrightText: 2022-2023 Chris Montgomery <chris@cdom.io>
#
# SPDX-License-Identifier: GPL-3.0-or-later
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
