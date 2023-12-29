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

mDMEZWPFehYJKwYBBAHaRw8BAQdAmBizgTiy/T+80kesR4AY2UcZKVgSEN3BMrzc
QaptpYG0IkphbWVzIEIuIEdyZWVyIDxqYmdyZWVyQGdtYWlsLmNvbT6ImQQTFgoA
QRYhBM0pisfbfQ5wu3epoGB1dGlMd3McBQJlY8V6AhsDBQkB4TOABQsJCAcCAiIC
BhUKCQgLAgQWAgMBAh4HAheAAAoJEGB1dGlMd3Mcb2UBAPcGn7SxjpN8BNgQp2dn
PfMFMJ6F4ySaGdgLj0XwsPZsAQDNCBZafilQjrcP5HePiKowz85qZBNA9S0IFc/y
FkfoDLg4BGVjxXoSCisGAQQBl1UBBQEBB0DWaZg1l263pblcabnT0Jchv6bBme3z
khjCAyQ3iOnFeQMBCAeIfgQYFgoAJhYhBM0pisfbfQ5wu3epoGB1dGlMd3McBQJl
Y8V6AhsMBQkB4TOAAAoJEGB1dGlMd3Mc7ZYBAMJqeyWIt0Z02ISj5uPn/tmO4bBX
p++izIbbyHp+LPSdAP9RuxFRF8xV6HnMtL50v3Tad5j2YI84ZN5p99t6F6rBD7gz
BGVjxiIWCSsGAQQB2kcPAQEHQPsMEIONoJtO6wHkLdGEf2VNpzhSkSmokIZgHnNR
vI2CiPUEGBYKACYWIQTNKYrH230OcLt3qaBgdXRpTHdzHAUCZWPGIgIbAgUJAeEz
gACBCRBgdXRpTHdzHHYgBBkWCgAdFiEEDWz+4/zeRemayvcSijniUYKrlwoFAmVj
xiIACgkQijniUYKrlwpjugD+MRtrwcsGowRvAzM7ECNBZMtdx/GqNc6smlZ0IZXz
1OcA/0NTK66OE63lbE8GsDCvnYWm3zh1rOiEVzJFcGGl/6cH2QIA/32rfiVubEsv
ygcC7cF7Gt6aXgjk1N6yPMUlyxB7hNSvAQClZQ8+ae3pWsTV4ujsitxLBCHkRXO+
SHBlxWsNCBwpCA==
=PLOu
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

