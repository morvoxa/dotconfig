{ pkgs, ... }: {
  services.displayManager.ly.enable = true;
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    kitty
    hyprlauncher
  ];
  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    }
  ];
}
