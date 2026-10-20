{ pkgs, CreateShortcut, ... }: {
  environment.systemPackages = with pkgs; [
    CreateShortcut.packages.${pkgs.stdenv.hostPlatform.system}.default
    neovim
    gcc
    gnumake
    cmake
    ninja
    fd
    ripgrep
    nodejs
    pnpm
    git
    fastfetch
    tree-sitter
    #lsp
    nixfmt
    nixd
    stylua
    lua-language-server
  ];
}
