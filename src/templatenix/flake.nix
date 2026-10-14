{
  description = "My custom Nix flake templates";

  outputs = { self }: {
    templates = {
      basic-1 = {
        path = ./basic-1;
        description = "A basic Nix flake development shell template";
        welcomeText = ''
          Run `nix develop` to enter the shell.
        '';
      };
    };
  };
}
