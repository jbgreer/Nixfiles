# gpg-agent.nix
{ lib, ... }: {

  programs.gpg.enable = lib.mkDefault true;
  programs.gpg.mutableKeys = lib.mkDefault false;
  programs.gpg.mutableTrust = lib.mkDefault false;
  programs.gpg.publicKeys = [
    {
      text = ''
-----BEGIN PGP PUBLIC KEY BLOCK-----

-----END PGP PUBLIC KEY BLOCK-----
'';
      trust = "ultimate";
    }
  ];

  # gnome-keyring is greedy and will override SSH_AUTH_SOCK where undesired
  # services.gnome-keyring.enable = lib.mkDefault false;

  services.gpg-agent.enable = lib.mkDefault true;
  services.gpg-agent.enableSshSupport = lib.mkDefault true;
  services.gpg-agent.enableExtraSocket = lib.mkDefault true;

}

