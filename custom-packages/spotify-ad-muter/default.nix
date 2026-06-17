{ lib, stdenvNoCC, makeWrapper, playerctl, pulseaudio, gawk, coreutils }:

stdenvNoCC.mkDerivation rec {
  pname = "spotify-ad-muter";
  version = "1.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];
  runtimeInputs = [ playerctl pulseaudio gawk coreutils ];

  installPhase = ''
    runHook preInstall

    install -Dm755 spotify-ad-muter.sh $out/bin/spotify-ad-muter
    patchShebangs $out/bin/spotify-ad-muter
    wrapProgram $out/bin/spotify-ad-muter \
      --prefix PATH : ${lib.makeBinPath runtimeInputs}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Auto-mute Spotify ads on NixOS";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
