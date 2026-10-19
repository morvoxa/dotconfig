{ ... }: {
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.enable = true;
  services.displayManager.ly.enable = true;

  environment.systemPackages = with pkgs; [
    xclip
    firefox
  ];
}
