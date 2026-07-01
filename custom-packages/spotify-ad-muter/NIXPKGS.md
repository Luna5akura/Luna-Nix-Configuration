# Nixpkgs contribution checklist

1. Copy files into a nixpkgs checkout:

   ```console
   mkdir -p pkgs/by-name/sp/spotify-ad-muter
   cp spotify-ad-muter.sh package.nix pkgs/by-name/sp/spotify-ad-muter/
   cp module.nix nixos/modules/services/audio/spotify-ad-muter.nix
   ```

2. Add the module path to `nixos/modules/module-list.nix`:

   ```nix
   ./services/audio/spotify-ad-muter.nix
   ```

3. Replace placeholder metadata:

   - `meta.homepage` in `package.nix`
   - `meta.maintainers` in `package.nix`
   - `meta.maintainers` in `spotify-ad-muter.nix`

4. If this is your first nixpkgs contribution, add yourself to
   `maintainers/maintainer-list.nix` in a separate commit.

5. Run checks from the nixpkgs checkout:

   ```console
   nix-build -A spotify-ad-muter
   nix-build -A spotify-ad-muter.tests.smoke
   nix-instantiate --eval -A nixosTests.spotify-ad-muter
   ```

   The last command is only relevant after adding a NixOS VM test.

6. Suggested commit messages:

   ```text
   maintainers: add <handle>
   spotify-ad-muter: init at 1.0.0
   nixos/spotify-ad-muter: init module
   ```
