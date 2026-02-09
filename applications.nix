
{ pkgs, configs,  ... }: {
  virtualisation.virtualbox.host.enable = true;

  programs.vim = {
    enable = true;
    package = pkgs.vim-full; # 确保用的是完整版
    defaultEditor = true;
  };

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
      plugins = [ "git" "sudo" ];
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
