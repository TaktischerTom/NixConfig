# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.roboto-mono
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = ["RobotoMono Nerd Font"];
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "eu";
    variant = "";
    options = "srvrkeys:none,caps:escape";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tom = {
    isNormalUser = true;
    description = "Tom";
    extraGroups = [ "networkmanager" "wheel" "openrazer"];
    packages = with pkgs; [
    kdePackages.kate
    vscodium
    vesktop
    lutris
    wineWowPackages.full
    git
    cmake
    libgcc
    gettext
    extra-cmake-modules
    protontricks
    python311
    xivlauncher
    xorg.xrdb
    linuxHeaders
    openrazer-daemon
    razergenie
    thunderbird
    bottles
    ncdu
    (writeShellScriptBin "me3" "/home/tom/.local/bin/me3")
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "tom";

  # Install firefox.
  programs.firefox.enable = true;

  # Install Steam.
  programs.steam.enable = true;

  # Install Thunar.
  programs.thunar.enable = true;

  # Install Yazi.
  programs.yazi.enable = true;

  # Install Gamemode.
  programs.gamemode.enable = true;

  # Install Gamescope.
  programs.gamescope.enable = true;

  # Install Flatpak.
  services.flatpak.enable = true;

  # Install Star Railway Launcher.
  programs.honkers-railway-launcher.enable = true;
  programs.anime-game-launcher.enable = true;
  imports = [inputs.aagl.nixosModules.default];

  programs.nix-ld.enable = true;

  nix.settings = inputs.aagl.nixConfig // {experimental-features = ["nix-command" "flakes"];};

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/tom/SystemConfig";
  };

  boot.loader.systemd-boot.configurationLimit = 10;

  services.udev.extraRules = import ./udevRules.nix;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  hardware.openrazer.enable = true;
  hardware.openrazer.users = ["tom"];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    (yazi.override {
      _7zz = _7zz-rar;  # Support for RAR extraction
    })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
