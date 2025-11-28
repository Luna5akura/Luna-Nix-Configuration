{ pkgs, ... }: with builtins; {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./custom-packages/entry.nix
    ./packages.nix
    ./desktop.nix
    ./applications.nix
  ];

  time.timeZone = "Asia/Shanghai";

  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
    };
  };

  users.users.luna = {
    isNormalUser = true;
    description = "Luna";
    extraGroups = [ "networkmanager" "wheel" "kvm" "adbusers" "vboxusers" "dialout" "input" "uinput" ];
  };
  users.defaultUserShell = pkgs.zsh;
  security.sudo.wheelNeedsPassword = false;

  environment.shells = with pkgs; [ zsh ];

  nix.optimise.automatic = true;

  nix.settings = {
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hydro.ac:EytfvyReWHFwhY9MCGimCIn46KQNfmv9y8E2NqlNfxQ="
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "httpd://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirrors.bfsu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      # "https://nix-bin.hydro.ac"
    ];
    accept-flake-config = true;
    max-jobs = 2;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  virtualisation = {
    docker = {
      enable = true;
    };
  };

  system.stateVersion = "24.11";

}
