{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.zst";
    CreateShortcut.url = "github:morvoxa/CreateShortcut";
  };

  outputs = { nixpkgs, CreateShortcut, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit CreateShortcut;
      };
      modules = [
        ./src/configuration.nix
        ./src/xfce.nix
        ./src/tools.nix
      ];
    };
  };
}
