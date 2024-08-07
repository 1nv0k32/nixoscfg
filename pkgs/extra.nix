{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    flameshot
    spotify
    obs-studio
    gimp
    vlc
    discord
    vscode
    pkgs-unstable.jetbrains.pycharm-community-bin
    gparted
    rivalcfg
    cobang
    rpi-imager
    yt-dlp
    media-downloader
    tor-browser-bundle-bin
    wineWowPackages.stable
    winetricks

    otpclient
    yubikey-manager
    yubikey-manager-qt

    evince
    gnome-network-displays
    gnome.gnome-terminal
    gnome.dconf-editor
    gnome.gnome-tweaks
    gnome.nautilus
    gnome.file-roller
    gnome.gnome-calculator
    gnome.eog
    gnome.geary
    gnome.gnome-calendar

    gns3-gui
    gns3-server
    dynamips
    inetutils

    stm32cubemx
    stm32loader
    stm32flash

    win-virtio
    virt-manager
    vagrant
    krew
    nixos-generators
    distrobox
    quickemu
    pavucontrol
    networkmanagerapplet
    alsa-utils
    pulseaudio
    android-tools

    nmap
    valgrind
    radare2
    pwntools
    pwndbg
    aircrack-ng
    binwalk
    burpsuite
    ghidra-bin
    pkgs-unstable.proxmark3
  ];

  services.udev.packages = with pkgs; [
    platformio-core
    openocd
    yubikey-personalization
    pkgs-unstable.proxmark3
  ];
}

# vim:expandtab ts=2 sw=2
