{ lib, stdenvNoCC, bash, playerctl, pulseaudio, gawk }:

stdenvNoCC.mkDerivation rec {
  pname = "spotify-ad-muter";
  version = "1.0";

  # 直接嵌入脚本内容（或替换为 src = ./script.sh;）
  src = ./.;

  nativeBuildInputs = [ bash ];
  buildInputs = [ playerctl pulseaudio gawk ];

  installPhase = ''
    install -Dm755 spotify-ad-muter.sh $out/bin/spotify-ad-muter
  '';

  meta = with lib; {
    description = "Auto-mute Spotify ads on NixOS";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.yourname ];
  };
}
