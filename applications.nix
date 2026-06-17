
{ pkgs, configs,  ... }: {
  virtualisation.virtualbox.host.enable = true;

  programs.vim = {
    enable = true;
    package = (pkgs.vim-full.override { }).customize {
      name = "vim";
      vimrcConfig = {
        customRC = ''
          " 尝试读取用户目录下的 .vimrc
          if filereadable(expand("~/.vimrc"))
            source ~/.vimrc
          endif

          autocmd BufNewFile,BufRead *.tsx set filetype=typescriptreact

          let g:fzf_preview_window = 'right:50%'
          syntax on

          nnoremap <C-p> :Files<CR>           
          nnoremap <C-g> :GFiles<CR>         
          nnoremap <C-b> :Buffers<CR>        
          nnoremap <C-f> :Rg<CR>            

        '';
        packages.myplugins = with pkgs.vimPlugins; {
          start = [
            vim-surround
            fzf-vim
            vim-jsx-pretty 
          ];   
          opt   = [ ];
        };
      };
    };
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
