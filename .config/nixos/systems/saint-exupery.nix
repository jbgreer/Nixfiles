# saint-exupery.nix
{ lib, pkgs, ... }: {

  networking.hostName = "saint-exupery";

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_testing;
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" "tpm_crb" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  #
  # INSERT SNIPPET FOR DEVICES
  # 

  # 
  # END SNIPPET FOR DEVICES
  # 
  
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;

  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";

  # Enable LVFS testing to get UEFI updates
  services.fwupd.extraRemotes = [ "lvfs-testing" ];

  # Enable fractional scaling
  #services.xserver.desktopManager.gnome = {
    #extraGSettingsOverrides = ''
      #[org.gnome.mutter]
      #experimental-features=['scale-monitor-framebuffer']
    #'';
    #extraGSettingsOverridePackages = [ pkgs.gnome.mutter ];
  #};

  boot.kernelParams = [
    "cpufreq.default_governor=powersave"
    "initcall_blacklist=cpufreq_gov_userspace_init"
  ];

  security.pam.services.login.fprintAuth = false;
  # similarly to how other distributions handle the fingerprinting login
  security.pam.services.gdm-fingerprint.text = ''
    auth       required                    pam_shells.so
    auth       requisite                   pam_nologin.so
    auth       requisite                   pam_faillock.so      preauth
    auth       required                    ${pkgs.fprintd}/lib/security/pam_fprintd.so
    auth       optional                    pam_permit.so
    auth       required                    pam_env.so
    #auth       [success=ok default=1]      ${pkgs.gnome.gdm}/lib/security/pam_gdm.so
    #auth       optional                    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so
    account    include                     login
    password   required                    pam_deny.so
    session    include                     login
    #session    optional                    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
  '';

  # Set display settings with 150% fractional scaling
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${pkgs.writeText "gdm-monitors.xml" ''
      <monitors version="2">
        <configuration>
          <logicalmonitor>
            <x>0</x>
            <y>0</y>
            <scale>1.5009980201721191</scale>
            <primary>yes</primary>
            <monitor>
              <monitorspec>
                <connector>eDP-1</connector>
                <vendor>BOE</vendor>
                <product>0x095f</product>
                <serial>0x00000000</serial>
              </monitorspec>
              <mode>
                <width>2256</width>
                <height>1504</height>
                <rate>59.999</rate>
              </mode>
            </monitor>
          </logicalmonitor>
        </configuration>
      </monitors>
    ''}"
  ];

  # User accounts
  users.mutableUsers = false;

  users.users.jbgreer = {
    isNormalUser = true;
    description = "Jim Greer";
    extraGroups = [ "networkmanager" "wheel" ];
    hashedPasswordFile = "/persist/passwords/jbgreer";
  };

  environment.systemPackages = with pkgs; [
    dmidecode
    pciutils
    sbctl
    tpm2-tss
  ];

  networking.useDHCP = lib.mkDefault true;
  hardware.wirelessRegulatoryDatabase = true;
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="US"
  '';

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  #services.gnome.gnome-keyring.enable = lib.mkForce false;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = "23.11";

  nix.settings.experimental-features = "nix-command flakes";
}

