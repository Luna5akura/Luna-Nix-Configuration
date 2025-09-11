{ pkgs, ... }:
with pkgs;
with builtins;
with (import ./utilities.nix);
let packages = {
  cliPkgs = [
    git
    gh
    vim
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
    thefuck
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
    python311Packages.manim
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
    nur.repos.linyinfeng.wemeet
    xclip
    desktop-file-utils
    vscode
    qq
    google-chrome
    telegram-desktop
    zotero
    netease-cloud-music-gtk
    libreoffice
    lightspark
    aseprite
    spotify
    godot_4
    discord
    lmms
    spotify-ad-muter
    feishu
    musescore	
  ] ++ (with kdePackages; [
    kolourpaint
    partitionmanager
    filelight
    kdenlive
    kmail
    accounts-qt
    kmail-account-wizard
    krita
    v2raya
    merkuro
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
    wineWowPackages.waylandFull
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
