{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-26.05/nixexprs.tar.zst";
  };

  outputs = { nixpkgs, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        ./tools.nix
        ./hyprland.nix

      ];
    };
  };
}
