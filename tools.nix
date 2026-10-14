{
  pkgs,
  inputs,
  ...
}:
{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    #neovim
    neovim
    gcc
    tree-sitter
    nixfmt
    stylua
    #dev
    git
    nodejs
    pnpm
    #gui
    firefox
    obs-studio
  ];
  programs.direnv.enable = true;
}
