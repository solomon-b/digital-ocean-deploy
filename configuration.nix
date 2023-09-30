{ modulesPath, config, lib, pkgs, ... }: {

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config-zfs.nix
  ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  fileSystems = {
    "/".neededForBoot = true;
    "/var/log".neededForBoot = true;
  };

  networking = {
    hostName = "gnostic-ascension";
    hostId = "63d9d016";
    useNetworkd = true;
    dhcpcd.enable = false;
    useDHCP = true;
    firewall.enable = true;
  };

  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
    pkgs.vim
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID/tM37nhuUIVfJB/nAoFbipU3A9Fv9+MldrjHfumxvn solomon@zodiacal-light"
  ];

  system.stateVersion = "23.05";
}
