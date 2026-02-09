{ pkgs, ... }:
with pkgs;
with builtins;
with (import ./utilities.nix);
let packages = {
  cliPkgs = [
    git
    gh
    ((pkgs."vim-full".override { }).customize {
      name = "vim-full";
      vimrcConfig.customRC = ''
        " 尝试读取用户目录下的 .vimrc
        if filereadable(expand("~/.vimrc"))
          source ~/.vimrc
        endif
      '';
    })
    lsd
    fzf
    zip
    unzip
    delta
    tealdeer
    bat
    wget
    screenfetch
    ripgrep
    duf
    dust
    fd
    bottom
    procs
    httpie
    dog
    broot
    wakatime-cli
    tokei
    nil
    lsof
    hexyl
    wireguard-tools
    ffmpeg
    tree
    postgresql
    jq
    unrar-wrapper
    pandoc
    djvu2pdf
    nushell
    screen
    p7zip
    traceroute
    krb5
    openssl
    softether
    libinput
    evtest
    xdotool
    xbindkeys
    docker
  ];

  mcuPackages = [
    sdcc   
  ];

  pythonPkgs = [
    python311
    python311Packages.pandas
    python311Packages.numpy
    python311Packages.scikit-learn
    python311Packages.scipy
    python311Packages.matplotlib
  ];

  clangPkgs = [
    gcc
    gdb
    cmake
    gnumake
  ];

  javascriptPkgs = [
    nodejs-slim_latest
    pnpm
    yarn
    prisma
  ];

  haskellPkgs = with haskellPackages; [
    ghc
    haskell-language-server
  ];

  rustPkgs = [
    rustup
  ];

  androidPkgs = [
    # android-studio
  ];

  desktopPkgs = [
    home-manager
    xclip
    desktop-file-utils
    vscode
    qq
    google-chrome
    telegram-desktop
    zotero
    libreoffice
    #  aseprite
    spotify
    godotPackages_4_6.godot
    discord
    lmms
    spotify-ad-muter
    musescore	
    nethack
  ] ++ (with kdePackages; [
    kolourpaint
    partitionmanager
    filelight
    kmail
    accounts-qt
    kmail-account-wizard
    krita
    v2raya
    cataclysm-dda
  ]);

  videoAndAudioPkgs = [
    obs-studio
    vlc
    peek
    helvum
    qpwgraph
    playerctl
  ];

  ctfPkgs = [
    burpsuite
  ];

  gamePkgs = [
    prismlauncher
    # olympus
  ];

  winePkgs = [
    wineWow64Packages.stable
    winetricks
    samba
  ];

  carPkgs = [
    socat
  ];

  notePkgs = [
    typst
  ];
  downloadPkgs = [
    aria2
    uget
  ];

  embedPkgs = [
    stm32cubemx
  ];
};
in {
  environment.systemPackages = (foldlSet opCon [] packages);

#  environment.systemPackages = (foldlSet opCon [] packages) ++ [
#    (import <nixos> {}).musescore
#];
}
