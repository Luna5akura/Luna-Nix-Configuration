
{ pkgs, ... }: {
  virtualisation.virtualbox.host.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      libGL
    ];
  };

  programs.direnv.enable = true;

  programs.steam = {
    enable = true;
    fontPackages = with pkgs; [ noto-fonts-cjk-sans ];
  };

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "thefuck" "sudo" ];
      theme = "robbyrussell";
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.adb.enable = true;

  programs.kdeconnect.enable = true;

  services.static-web-server = {
    enable = false;
    listen = "[::]:1627";
    root = "/var/www/luna";
    configuration = {
      directory-listing = false;
    };
  };
}
