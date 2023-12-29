# gpg-agent.nix
{ lib, ... }: {

  programs.gpg = {
    enable = lib.mkDefault true;
    mutableKeys = lib.mkDefault false;
    mutableTrust = lib.mkDefault false;
    publicKeys = [
      {
        text = ''
  -----BEGIN PGP PUBLIC KEY BLOCK-----
  
  -----END PGP PUBLIC KEY BLOCK-----
  '';
        trust = "ultimate";
      }
    ];

  };

  services.gpg-agent = {
    enable = lib.mkDefault true;
    enableSshSupport = lib.mkDefault true;
    enableExtraSocket = lib.mkDefault true;
  };
}

