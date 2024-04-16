{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    # Unstable releases for more up to date packages (only use when  necessary)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: {
    # Please replace nixos with your hostname -- something
    # like jarrodangove-pc (can be found by entering 'hostname' in
    # a terminal)
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";

      specialArgs = {
        pkgs-unstable  = import nixpkgs-unstable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      };
      modules = [
        ./configuration.nix
      ];
    };
  };
}
