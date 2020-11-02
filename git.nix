{ config, pkgs, lib, ... }:

let
  gitignore = pkgs.writeText "gitignore.global" ''
    *~
    .Trash-*
    .nfs*
    .DS_Store
    ._*
    .Spotlight-V100
    .Trashes
    \#*\#
    *.elc
    tramp
    .\#*
    result/
  '';

  gitconfig = {
    color.ui = true;
    user = {
      email = "jamie@pagecloud.com";
      name = "Jamie Bertram";
    };
    github.user = "jhbertra";
    alias = {
      br = "branch";
      ch = "checkout";
      co = "commit";
      hist = "log --oneline --graph --decorate --all";
      pf = "push --force-with-lease";
      s = "status";
    };
    core = {
      editor = "${config.programs.vim.package}/bin/nvim";
      excludefile = "${gitignore}";
    };
    merge = {
      tool = "vimdiff";
      conflictstyle = "diff3";
    };
    mergetool = {
      keepBackup = false;
      prompt = false;
    };
    pull = {
      rebase = true;
    };
  };

in
  {
    environment.systemPackages = [ pkgs.git ];
    environment.etc."gitconfig".text = lib.generators.toINI {} gitconfig;
  }
