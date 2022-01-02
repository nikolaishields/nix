{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ext4" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams = [];
  boot.initrd.supportedFilesystems = [ "ext4" ];

  networking.hostName = "nas"; 
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";
  time.hardwareClockInLocalTime = true;

  virtualisation = {
    libvirtd.enable = true;
    podman.enable = true;
  };
  
  environment.systemPackages = with pkgs; [
    bash
    boundary
    cloudflared
    consul
    curl
    direnv
    docker-compose
    ffmpeg
    file
    firecracker
    firectl
    fwupd
    git
    htop
    ignite
    jq
    kitty
    lorri
    mpv
    neovim
    niv
    nomad
    podman
    ripgrep
    usbutils
    vagrant
    vault
    vim 
    waypoint
    wget
    zfs
    zsh
  ];

  # Update firmware 
  services.fwupd.enable = true;

  # X11 Keymap
  services.xserver.layout = "us";

  # Openssh
  services.openssh.enable = true;

  # Enable sound.
  sound.enable = false;
  hardware.pulseaudio.enable = false;

  # Security
  security.rtkit.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Groups
  users.groups = {
    consul.gid   = 1001;
    firecrkr.gid = 1002;
    media.gid    = 1003;
    metrics.gid  = 1004;
    nomad.gid    = 1005;
    podman.gid   = 1006;
    storage.gid  = 1007;
    vault.gid    = 1008;
  };

  # Users
  users.mutableUsers = false;
  

  users.users.nikolai = {
    uid = 1000;
    isNormalUser = true;
    home = "/home/nikolai";
    extraGroups = [ 
        "wheel"
        "networkmanager"
        "input"
        "libvirtd"
        "media"
        "storage"
        "metrics"
    ];
    openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMrs3AFRgL4YfA7aMAD7X3O9kihcSCJKY8GiyWYV6Jwx nikolai@nikolaishields.com"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQClYajEyvhqsc4kQ4fXqeu09Bunl75A30qcsVjHNXSThOaWks+DjKYeVE605Fs3iHRa6eHfRf58tCFsjwp3xlMn/uMVd1pjo6X+qGyQsmTCv6tFI281+EqquINrUMpSyAT+yTL4P/IEeu/MyYOpfz9Qvr75B+5sRpDJnmV2PS+WfbM6AyW3sIEfpzrNy4k8V0tuSCICEpgWweR78OMYFhN61k05yzXwkaGTpKWML0WH9uyLKYh6xuzWLxflm4N1cPJnaCFCcTD4Mp/FhRLXKxQuEIkACdKdOozuMxNEDk3PkzptRckuGqtPytyUOKIYo1Uo/ra9ddqohAgR+XcDLNhuOMijIbDpqKJ9YuiVPAz5AeGXJkzPfAl8ove0if/ALkn0S8EFBE/HrOpwqHhETO1y5Nl3rWTIIrmPmRFtgX8p6R4w9rY2nIXhtCNJE/JEYv5opjqxseR9GogFH3Tm2cnoOQEAur1HIS8HwKL60aGaJ6ojgAo7lzHqV2MyR9UBcdoBTREUoo2BlQZsmXQJ6/oAc+SlJDA+7UTr4C+haIlX3DzVOsN/VU+3RZho6ebVjpjnmzCwjGPmcHDtx3ILlWb9SvXwAE85zbYHGKoiv8K5D0Y0Wx0YkqdlrppN68uNjpAGx0n9ti/uK5T2EmPdC6VbfuCCVBK5tzx62qhgKG8p4Q== nikolai@nikolaishields.com"
    ];
  };

  users.users.svcuser = {
    uid = 1001;
    isNormalUser = false;
    isSystemUser = true;
    extraGroups = [
        "consul"
        "firecrkr"
        "input"
        "libvirtd" 
        "media" 
        "metrics"
        "networkmanager"
        "nomad"
        "podman"
        "storage" 
    ];
  };

  users.users.mediauser = {
    isNormalUser = false;
    isSystemUser = true;
    extraGroups = [ "media" ];
    uid = 1002;
  };

  # Programs
  programs.mtr.enable = true;

  system.stateVersion = "21.11";
}

