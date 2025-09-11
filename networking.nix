{ pkgs, config, ... }: let
  user = config.users.users.luna;
in {
  networking = {
    hostName = "luna";
    networkmanager.enable = true;

    firewall.enable = false;
  };

  services.v2raya.enable = true;

  programs.proxychains = {
    enable = true;
    package = pkgs.proxychains-ng;
    quietMode = true;
    proxies = {
      v2raya = {
        enable = true;
        type = "http";
        host = "127.0.0.1";
        port = 1643;
      };
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
