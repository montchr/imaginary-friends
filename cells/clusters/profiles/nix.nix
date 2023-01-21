# SPDX-FileCopyrightText: 2022-2023 Chris Montgomery <chris@cdom.io>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  pkgs,
  lib,
  ...
}: {
  nix = {
    gc.automatic = true;
    gc.dates = "weekly";
    optimise.automatic = true;

    nixPath = [
      "nixpkgs=${pkgs.path}"
      "nixos-config=/etc/nixos/configuration.nix"
    ];

    settings = {
      auto-optimise-store = true;
      allowed-users = ["@wheel"];
      trusted-users = ["root" "@wheel"];
      experimental-features = [
        "flakes"
        "nix-command"
        "repl-flake"
      ];
      accept-flake-config = true;
    };
  };
}
