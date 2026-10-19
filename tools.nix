{ pkgs, inputs, ... }: {

  environment.systemPackages = with pkgs; [
    inputs.CreateShortcut.packages.${pkgs.system}.default
    neovim
    gcc
    gnumake
    tree-sitter
    nixfmt
    git
  ];
}
