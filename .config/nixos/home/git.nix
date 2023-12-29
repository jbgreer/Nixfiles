# git.nix
{ lib, pkgs, ... }: {

  programs.git = {
    enable = lib.mkDefault true;
    package = lib.mkDefault pkgs.gitAndTools.gitFull;
    userName = lib.mkDefault "James B Greer";
    userEmail = lib.mkDefault "jbgreer@gmail.com";
    #signing.key = lib.mkDefault "";
    #signing.signByDefault = lib.mkDefault true;
    extraConfig.init.defaultBranch = "main";
    extraConfig.core.editor = "nvim";
    extraConfig.color.ui = "always";
    extraConfig.stash.showPatch = true;
    extraConfig.pull.ff = "only";
    extraConfig.push.autoSetupRemote = true;
  };
}


