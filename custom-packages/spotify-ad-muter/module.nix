{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.spotify-ad-muter;
in {
  options.services.spotify-ad-muter = {
    enable = mkEnableOption "Spotify Ad Muter service";

    user = mkOption {
      type = types.str;
      default = "luna";
      description = "User whose Spotify session should be monitored.";
    };

    resumeDelay = mkOption {
      type = types.int;
      default = 2;
      description = "Seconds to wait after an ad ends before restoring Spotify audio.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = builtins.hasAttr cfg.user config.users.users;
        message = "services.spotify-ad-muter.user must name an existing NixOS user.";
      }
      {
        assertion = cfg.resumeDelay >= 0;
        message = "services.spotify-ad-muter.resumeDelay must be zero or greater.";
      }
    ];

    systemd.services.spotify-ad-muter = {
      description = "Automute Spotify ads";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-user-sessions.service" ];
      environment.SPOTIFY_AD_MUTER_RESUME_DELAY = toString cfg.resumeDelay;
      serviceConfig = {
        User = cfg.user;
        ExecStart = "${pkgs.spotify-ad-muter}/bin/spotify-ad-muter";
        ExecStopPost = "${pkgs.spotify-ad-muter}/bin/spotify-ad-muter --restore";
        Restart = "always";
        RestartSec = "5s";
      };
    };

    environment.systemPackages = [ pkgs.spotify-ad-muter ];
  };
}
