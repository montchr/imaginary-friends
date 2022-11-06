{modulesPath, ...}: {
  imports = ["${modulesPath}/virtualisation/qemu-vm.nix"];

  # DNS fails for QEMU user networking (SLiRP) on macOS.  See:
  #
  # https://github.com/utmapp/UTM/issues/2353
  #
  # This works around that by using a public DNS server other than the
  # DNS server that QEMU provides (normally 10.0.2.3)
  networking.nameservers = ["1.1.1.1"];
}
