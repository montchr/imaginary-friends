# SPDX-FileCopyrightText: 2003-2022 Eelco Dolstra and the Nixpkgs/NixOS contributors
# SPDX-FileCopyrightText: 2022 Chris Montgomery <chris@cdom.io>
#
# SPDX-License-Identifier: GPL-3.0-or-later
# SPDX-License-Identifier: GPL-3.0-or-later OR MIT

{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "lint-staged";
  version = "13.0.3";

  src = fetchFromGitHub {
    owner = "okonet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gQrgDX0+fpLz4Izrw29ChwBUXXXrUyZqV7BWtz9Ru8k=";
  };

  npmDepsHash = "sha256-bBSM8jCPHqHkynayHslvjJhH7HshSrmp0O6RJNA0tdM=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Run linters on git staged files";
    homepage = "https://github.com/okonet/lint-staged";
    license = licenses.mit;
    maintainers = with maintainers; [montchr];
  };
}
