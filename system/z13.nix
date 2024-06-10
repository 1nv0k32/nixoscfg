{
  inputs,
  system,
  pkgs,
  lib,
  ...
}:
with lib;
{
  imports = [
    (import ../src/extra.nix)
    (import ../pkgs/extra.nix)
    (import ../overlays/initrd-luks.nix)
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    extraModprobeConfig = "options kvm_amd nested=1";
    initrd.kernelModules = [ "amdgpu" ];
  };

  services = {
    power-profiles-daemon.enable = mkForce false;
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 90;
        STOP_CHARGE_THRESH_BAT0 = 100;
      };
    };
    auto-cpufreq = {
      enable = true;
      settings = {
        "charger" = {
          governor = "performance";
          turbo = "always";
        };
        "battery" = {
          governor = "ondemand";
          scaling_min_freq = 400000;
          scaling_max_freq = 1600000;
          turbo = "never";
        };
      };
    };
    keyd = {
      enable = true;
      internal = {
        ids = [ "0001:0001" ];
        settings = {
          main = {
            "102nd" = "layer(shift)";
          };
        };
      };
    };
  };
}

# vim:expandtab ts=2 sw=2
