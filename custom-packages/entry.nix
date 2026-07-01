let
  nixosUnstable = final:
    import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/e73de5be04e0eff4190a1432b946d469c794e7b4.tar.gz";
      sha256 = "04csm31wfzrhmr0qrq74gay01cbx32b7phw540j13lqdry8casx4";
    }) {
      system = final.stdenv.hostPlatform.system;
      config = final.config;
    };
in {
  imports = [ ./spotify-ad-muter/module.nix ];

  nixpkgs.overlays = [
    (final: prev:
      let
        unstable = nixosUnstable final;
      in {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          pkgs = final;
        };

        nethack = unstable.nethack;

        # olympus = final.callPackage ./olympus/package.nix {};
        spotify-ad-muter = final.callPackage ./spotify-ad-muter/package.nix {};
      })
  ];

  services.spotify-ad-muter.enable = true;
  environment.pathsToLink = [ "/libexec" ];
}
