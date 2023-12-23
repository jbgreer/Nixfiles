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
    #appimage-run
    #dmidecode
    neovim
    #kakoune
    #yubikey-personalization
    #gcc
    #gnupg
    #capitaine-cursors
    pciutils
    sbctl
    #pinentry-gnome
    #wl-clipboard
    #gnome.gnome-tweaks
    #gnome.gnome-boxes
  #]) #++ (with pkgs.gnomeExtensions; [
    #gsconnect
    #tailscale-status
    #night-theme-switcher
    #blur-my-shell
  ]);

  # Remove unused/icky packages
  #environment.gnome.excludePackages = (with pkgs.gnome; [
    #epiphany
    #geary
    #gedit
    #gnome-contacts
    #gnome-music
  #]);

  #services.xserver.excludePackages = with pkgs; [
    #xterm
  #];

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

  # Add Docker
  #virtualisation.docker.enable = true;

  # Wayland-specific configuration
  #services.xserver.displayManager.gdm.wayland = true;
  #environment.sessionVariables = {
    # keepassxc / QT apps will use xwayland by default - override
    #QT_QPA_PLATFORM = "wayland";
    # Ensure Electron / "Ozone platform" apps enable using wayland in NixOS
    #NIXOS_OZONE_WL = "1";
  #};

  # Force gnome-keyring to disable, because it likes to bully gpg-agent
  #services.gnome.gnome-keyring.enable = lib.mkForce false;

  # Enable fwupd - does not work well with lanzaboote at the moment
  services.fwupd.enable = true;

  # gpaste has a daemon, must be enabled over package
  #programs.gpaste.enable = true;

  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';

}

