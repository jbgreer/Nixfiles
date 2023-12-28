# git.nix
{ lib, pkgs, ... }: {
  programs.git.enable = lib.mkDefault true;
  programs.git.package = lib.mkDefault pkgs.gitAndTools.gitFull;
  programs.git.userName = lib.mkDefault "James B Greer";
  programs.git.userEmail = lib.mkDefault "jbgreer@gmail.com";
  #programs.git.signing.key = lib.mkDefault "";
  #programs.git.signing.signByDefault = lib.mkDefault true;
  programs.git.extraConfig.init.defaultBranch = "main";
  programs.git.extraConfig.core.editor = "nvim";
  programs.git.extraConfig.color.ui = "always";
  programs.git.extraConfig.stash.showPatch = true;
  programs.git.extraConfig.pull.ff = "only";
  programs.git.extraConfig.push.autoSetupRemote = true;
}


