{
  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-old.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/2405.5.4";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs =
    { self, ... }@inputs:
    {
      stateVersion = "24.05";
      system = "x86_64-linux";
      baseModules = [
        inputs.home-manager.nixosModules.home-manager
        inputs.nixvim.nixosModules.nixvim
        (import "${self}/modules")
        (import "${self}/src/base.nix")
        (import "${self}/pkgs/base.nix")
      ];
    };
}

# vim:expandtab ts=2 sw=2
