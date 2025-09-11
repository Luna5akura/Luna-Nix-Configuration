{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.spotify-ad-muter;
in {
  options.services.spotify-ad-muter = {
    enable = mkEnableOption "Spotify Ad Muter service";
  };

  config = mkIf cfg.enable {
    systemd.user.services.spotify-ad-muter = {
      description = "Automute Spotify ads";
      wantedBy = [ "default.target" ]; # 用户登录时启动
      serviceConfig = {
        ExecStart = "${pkgs.spotify-ad-muter}/bin/spotify-ad-muter";
        Restart = "always";
        RestartSec = 5;
      };
    };

    environment.systemPackages = [ pkgs.spotify-ad-muter ];
  };
}
