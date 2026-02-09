{ ... }: {
  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
    
    vim = vim_full.customize {
      name = "vim";
      vimrcConfig.customRC = ''
        set clipboard=unnamedplus
      '';
    };
  
    # olympus = callPackage ./olympus/package.nix {};
    baidunetdisk = callPackage ./baidunetdisk/package.nix {};
    spotify-ad-muter = callPackage ./spotify-ad-muter/default.nix {};
  };
  
  imports = [ /etc/nixos/custom-packages/spotify-ad-muter/module.nix ];
  services.spotify-ad-muter.enable = true;
  environment.pathsToLink = [ "/libexec" ];
}
