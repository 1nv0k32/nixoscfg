{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  customConfigs = (import ./configs.nix { inherit inputs pkgs lib; });
in
with lib;
{
  boot = {
    blacklistedKernelModules = mkDefault [ "snd_pcsp" ];
    loader = {
      efi.canTouchEfiVariables = mkDefault true;
      timeout = mkDefault 0;
      systemd-boot = {
        enable = mkDefault true;
        editor = mkForce false;
        consoleMode = mkDefault "max";
      };
    };
    initrd.systemd = {
      enable = mkDefault true;
      extraConfig = customConfigs.SYSTEMD_CONFIG;
    };
  };

  networking = {
    networkmanager = {
      enable = mkDefault true;
      dns = mkDefault "systemd-resolved";
      settings = {
        main = {
          no-auto-default = "*";
          systemd-resolved = true;
        };
      };
    };
    firewall = {
      enable = mkDefault true;
      checkReversePath = mkDefault false;
      allowPing = mkDefault false;
      allowedTCPPorts = mkDefault [ ];
      allowedTCPPortRanges = mkDefault [ ];
      allowedUDPPorts = mkDefault [ ];
      allowedUDPPortRanges = mkDefault [ ];
    };
  };

  systemd = {
    watchdog = {
      runtimeTime = "off";
      rebootTime = "off";
      kexecTime = "off";
    };
  };

  console = {
    earlySetup = mkDefault true;
    packages = [ pkgs.terminus_font ];
    font = mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v24b.psf.gz";
    keyMap = mkDefault "us";
  };

  sound.enable = mkDefault true;
  services = {
    fstrim.enable = mkDefault true;
    fprintd.enable = mkDefault true;
    fwupd.enable = mkDefault true;
    pcscd.enable = mkDefault true;
    avahi = {
      enable = mkDefault true;
      nssmdns4 = mkDefault true;
    };
    gnome = {
      core-utilities.enable = mkDefault true;
      gnome-keyring.enable = mkDefault true;
    };
    resolved = {
      enable = mkDefault true;
      extraConfig = customConfigs.RESOLVED_CONFIG;
    };
    logind =
      let
        defaultAction = "lock";
        suspendAction = "suspend";
      in
      {
        lidSwitch = mkDefault suspendAction;
        lidSwitchDocked = mkDefault defaultAction;
        lidSwitchExternalPower = mkDefault defaultAction;
        suspendKey = mkDefault defaultAction;
        suspendKeyLongPress = mkDefault defaultAction;
        rebootKey = mkDefault defaultAction;
        rebootKeyLongPress = mkDefault defaultAction;
        powerKey = mkDefault defaultAction;
        powerKeyLongPress = mkDefault defaultAction;
        hibernateKey = mkDefault defaultAction;
        hibernateKeyLongPress = mkDefault defaultAction;
        killUserProcesses = mkDefault true;
        extraConfig = customConfigs.LOGIND_CONFIG;
      };
    xserver = {
      enable = mkDefault true;
      xkb.layout = mkDefault "us";
      desktopManager = {
        gnome.enable = mkDefault true;
        wallpaper.mode = mkDefault "center";
      };
      displayManager = {
        gdm.enable = mkDefault true;
      };
    };
    displayManager = {
      defaultSession = mkDefault "gnome";
    };
    pipewire = {
      enable = mkDefault true;
      alsa.enable = mkDefault true;
      alsa.support32Bit = mkDefault true;
      pulse.enable = mkDefault true;
    };
  };

  hardware = {
    opengl.driSupport32Bit = mkDefault true;
    pulseaudio.enable = mkForce false;
    bluetooth.powerOnBoot = mkDefault false;
    wirelessRegulatoryDatabase = mkDefault true;
  };

  security = {
    rtkit.enable = mkDefault true;
    pam = {
      services = {
        login.fprintAuth = mkDefault false;
        gdm-fingerprint.fprintAuth = mkDefault true;
        gdm.enableGnomeKeyring = mkDefault true;
      };
    };
    wrappers.ubridge = {
      source = mkDefault "${pkgs.ubridge}/bin/ubridge";
      capabilities = mkDefault "cap_net_admin,cap_net_raw=ep";
      owner = mkDefault "root";
      group = mkDefault "ubridge";
      permissions = mkDefault "u+rx,g+x";
    };
  };

  virtualisation = {
    libvirtd = {
      enable = mkDefault true;
    };
  };

  programs = {
    mtr.enable = mkDefault true;
    wireshark = {
      enable = mkDefault true;
      package = mkDefault pkgs.wireshark;
    };
    firefox = {
      enable = mkDefault true;
    };
    winbox = {
      enable = mkDefault true;
      openFirewall = mkDefault true;
      package = mkDefault pkgs.pkgs-unstable.winbox;
    };
  };

  fonts = {
    packages = with pkgs; [
      ubuntu_font_family
      vazir-fonts
      nerdfonts
      (nerdfonts.override { fonts = [ "Noto" ]; })
    ];
    enableDefaultPackages = mkDefault true;
    fontconfig.defaultFonts = {
      serif = mkDefault [
        "Vazirmatn"
        "DejaVu Serif"
      ];
      sansSerif = mkDefault [
        "Vazirmatn"
        "DejaVu Sans"
      ];
    };
  };
}

# vim:expandtab ts=2 sw=2
