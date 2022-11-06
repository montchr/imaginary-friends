{
  imports = [./common.nix];
  nix.settings = {
    auto-optimise-store = true;

    min-free = 1024 * 1024 * 1024;

    max-free = 3 * 1024 * 1024 * 1024;

    trusted-users = ["root" "builder"];
  };

  services.openssh.enable = true;

  system.stateVersion = "22.11";

  users.users.builder = {
    isNormalUser = true;

    # openssh.authorizedKeys.keyFiles = [ ./keys/nixbld_ed25519.pub ];
  };

  virtualisation = {
    diskSize = 20 * 1024;

    forwardPorts = [
      {
        from = "host";
        guest.port = 22;
        host.port = 22;
      }
    ];

    # Disable graphics for the builder since users will likely want to
    # run it non-interactively in the background.
    graphics = false;

    # If we don't enable this option then the host will fail to delegate
    # builds to the guest, because:
    #
    # - The host will lock the path to build
    # - The host will delegate the build to the guest
    # - The guest will attempt to lock the same path and fail because
    #   the lockfile on the host is visible on the guest
    #
    # Snapshotting the host's /nix/store as an image isolates the guest
    # VM's /nix/store from the host's /nix/store, preventing this
    # problem.
    useNixStoreImage = true;

    # Obviously the /nix/store needs to be writable on the guest in
    # order for it to perform builds.
    writableStore = true;

    # This ensures that anything built on the guest isn't lost when the
    # guest is restarted.
    writableStoreUseTmpfs = false;
  };
}
