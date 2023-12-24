# system.nix
# Common system configuration
{ lib, pkgs, ... }: {

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.utf8";

  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;

  # Enable the X11 windowing system.
  #services.xserver = {
    #enable = true;
    #displayManager.gdm.enable = true;
    #desktopManager.gnome.enable = true;
    #layout = "us";
    #xkbVariant = "";
  #};

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable sound using pipewire
  #sound.enable = true;
  #hardware.pulseaudio.enable = false;
  #security.rtkit.enable = true;
  #services.pipewire = {
    #enable = true;
    #alsa.enable = true;
    #alsa.support32Bit = true;
    #pulse.enable = true;
  #};

  environment.systemPackages = (with pkgs; [
    dmidecode
    neovim
    gcc
    gnupg
    pciutils
    sbctl
  ]);

  # Any packages for root that would otherwise be in home-manager
  users.users.root.packages = with pkgs; [
    bind
    git
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      ibm-plex
      merriweather
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "FiraCode" "UbuntuMono" "CascadiaCode" "Noto" ]; })
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Merriweather" ];
        sansSerif = [ "IBM Plex Sans" ];
        monospace = [ "FiraCode" "CascadiaCode" ];
      };

      antialias = true;
      subpixel = {
        rgba = "none";
        lcdfilter = "none";
      };
    };
  };

  # Enable fwupd - does not work well with lanzaboote at the moment
  services.fwupd.enable = true;

  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';
}

