{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    #neovim
    neovim
    gcc
    tree-sitter
    nixfmt
    stylua
    nerd-fonts.jetbrains-mono
    #dev
    git
    #gui
    firefox
  ];
}
