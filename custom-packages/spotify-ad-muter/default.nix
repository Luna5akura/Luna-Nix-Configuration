{
  lib,
  stdenvNoCC,
  makeWrapper,
  runCommand,
  playerctl,
  pulseaudio,
  gawk,
  coreutils,
}:

import ./package.nix {
  inherit
    lib
    stdenvNoCC
    makeWrapper
    runCommand
    playerctl
    pulseaudio
    gawk
    coreutils
    ;
}
