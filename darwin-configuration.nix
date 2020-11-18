{ config, lib, pkgs, ... }:

{
  imports = [
    ./defaults.nix
    # ./direnv.nix
    ./git.nix
    ./packages.nix
    ./shells.nix
    ./vim.nix
    ./wm.nix
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    _1password
    curl
    fzf
    htop
    jq
    skhd
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  nix.extraOptions = ''
    gc-keep-derivations = true
    gc-keep-outputs = true
    min-free = 17179870000
    max-free = 17179870000
    log-lines = 128
  '';

  time.timeZone = "America/Toronto";

  services.nix-daemon.enable = true;
  services.activate-system.enable = true;
  programs.nix-index.enable = true;

  users.nix.configureBuildUsers = true;
  users.nix.nrBuildUsers = 32;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
