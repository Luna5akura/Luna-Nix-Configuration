# spotify-ad-muter

`spotify-ad-muter` monitors Spotify through MPRIS metadata and mutes the
Spotify PulseAudio stream while advertisement-like metadata is playing. It
restores the previous mute state when normal Spotify playback resumes.

## Requirements

- Spotify desktop client
- `playerctl`
- PulseAudio-compatible `pactl`, including PipeWire PulseAudio

## NixOS module

```nix
{
  services.spotify-ad-muter = {
    enable = true;
    resumeDelay = 2;
    commandTimeout = 2;
  };
}
```

The module installs a systemd user service. Start it for the current user with:

```console
systemctl --user start spotify-ad-muter.service
```

## Nixpkgs layout

For an upstream nixpkgs contribution, place the files as follows:

```text
pkgs/by-name/sp/spotify-ad-muter/package.nix
pkgs/by-name/sp/spotify-ad-muter/spotify-ad-muter.sh
nixos/modules/services/audio/spotify-ad-muter.nix
```

Then add the NixOS module to `nixos/modules/module-list.nix` and set a real
nixpkgs maintainer in both `package.nix` and the module.
