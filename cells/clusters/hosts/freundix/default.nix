{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./filesystems.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "freundix"; # Define your hostname.

  # SPICE for QEMU graphics.
  services.spice-vdagentd.enable = true;
  # via https://github.com/mitchellh/nixos-config/blob/9b06df27db44f68715942bf520a431a2356c8649/machines/vm-aarch64-utm.nix#L12-L13
  # environment.variables.LIBGL_ALWAYS_SOFTWARE = "1";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cdom = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [];
    initialPassword = "cdom";
  };

  users.users.builder = {
    isNormalUser = true;
  };

  users.users.root.initialPassword = "root";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat
    cachix
    curl
    fd
    git
    gnumake
    neovim
    ripgrep
    rsync
    rxvt_unicode
    tealdeer
    wget
    xclip

    # via https://github.com/mitchellh/nixos-config/blob/9b06df27db44f68715942bf520a431a2356c8649/machines/vm-shared.nix#L104-L108
    (writeShellScriptBin "xrandr-auto" ''
      xrandr --output Virtual-1 --auto
    '')
  ];

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  services.openssh.permitRootLogin = "yes";

  security.sudo.wheelNeedsPassword = false;

  networking.interfaces.enp0s1.useDHCP = true;
  networking.firewall.enable = false;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.pathsToLink = ["/share/fish"];

  services.xserver = {
    enable = true;
    layout = "us";
    dpi = 220;

    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "fill";
    };

    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;

      # AARCH64: For now, on Apple Silicon, we must manually set the
      # display resolution. This is a known issue with VMware Fusion.
      sessionCommands = ''
        ${pkgs.xorg.xset}/bin/xset r rate 200 40
      '';
    };

    windowManager = {
      i3.enable = true;
    };
  };

  # hardware.video.hidpi.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  system.stateVersion = "22.11"; # Did you read the comment?
}
