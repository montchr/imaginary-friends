# SPDX-FileCopyrightText: 2022-2023 Chris Montgomery <chris@cdom.io>
#
# SPDX-License-Identifier: GPL-3.0-or-later
# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  # bootDevice = "/dev/disk/by-label/boot";
  subvol = name: {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [
      "subvol=@${name}"
      "defaults"
      "x-mount.mkdir"
      "noatime"
      "compress=zstd"
    ];
  };
in {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # boot.initrd.availableKernelModules = ["xhci_pci" "virtio_pci" "usbhid" "usb_storage" "sr_mod"];
  # via https://github.com/mitchellh/nixos-config/blob/9b06df27db44f68715942bf520a431a2356c8649/hardware/vm-aarch64-utm.nix#L11
  boot.initrd.availableKernelModules = ["xhci_pci" "uhci_hcd" "virtio_pci" "usbhid" "usb_storage" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = subvol "root";
  fileSystems."/nix" = subvol "store";
  fileSystems."/var/log" = subvol "log";
  fileSystems."/home" = subvol "home";
  fileSystems."/persist" = subvol "persist";
  fileSystems."/var/lib/postgres" = subvol "postgres";

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };
  swapDevices = [{label = "swap";}];
}
