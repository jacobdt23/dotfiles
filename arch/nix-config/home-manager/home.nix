{ config, pkgs, ... }:

{
  home.username = "jacob";
  home.homeDirectory = "/home/jacob";
  home.stateVersion = "25.05";

  # Add packages you want to manage with Nix here.
  home.packages = [
    pkgs.htop
    pkgs.neovim
    pkgs.ripgrep
  ];

  programs.fish = {
    enable = true;
    # This is the corrected line
    interactiveShellInit = ''
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    '';
  };

  # Let Home Manager manage itself.
  programs.home-manager.enable = true;
}
