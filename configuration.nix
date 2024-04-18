# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# TODO:
# - Customize lock screen
# - Configure SSH stuff (do it right this time, with keys for all devices) 
# - Reset password and actually memorize it
# - Create a snapshot of your current fedora build and save it to the NAS

{ config, pkgs, pkgs-unstable, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      # DO NOT COPY THIS HARDWAR CONFIG IF YOU INSTALL THIS ON 
      # YOUR COMPUTER -- LET THE INSTALLER GENERATE A NEW ONE 
      # FOR YOU!!!! 
      ./hardware-configuration.nix
    ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.lunarvim              # vim but cool
    pkgs.wget 
    pkgs.git
    pkgs.picom                 # compositor that enables transparency
    pkgs.gnome.gnome-keyring
    pkgs.polkit_gnome
    pkgs.pulseaudioFull
    pkgs.unrar
    pkgs.unzip
    pkgs.zoxide
    pkgs.zsh
    pkgs.firefox
    pkgs.xclip
    pkgs.arandr                # xrander GUI for managing monitor layout
    pkgs.neofetch              # literally just for flexing
    pkgs.feh                   # for setting wallpaper
    pkgs.xorg.xkill            # mostly to kill off the extra polybar when I reload i3
    pkgs.maim                  # used to set Shift+Ctrl+n to take area screenshots in the i3 config
    pkgs.btop                  # fancy system monitor
    pkgs.gh                    # github api for command line
    pkgs.typst                 # like LaTeX but better :)
    pkgs.pandoc                # for converting between document types
    pkgs.tailscale
    pkgs.eza
    pkgs.zathura
    pkgs.dunst
    pkgs.zsh-powerlevel10k
    pkgs.pandoc
    pkgs.ueberzugpp           # this allows for image preview in yazi
    pkgs.ripgrep
    pkgs.ripgrep-all          # wrapper for ripgrep that can search in pdf, docx, epub, etc
    pkgs.fzf

    # Unstable packages -- despite their name, this is usually just latest stable release 
    pkgs-unstable.julia
    pkgs-unstable.alacritty
    pkgs-unstable.yazi

    # LaTeX stuff
    (pkgs.texlive.combine {
      inherit (pkgs.texlive)
      scheme-full
      # add  missing packages here
      ;
    })
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Edmonton";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Configure keymap in X11
  services = {
    xserver = {
      layout = "us";
      xkbVariant = "";
      enable = true;
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          i3lock
          dmenu
          polybar
        ];
        };
      desktopManager = {
        xterm.enable = true;
        xfce = {
          enable  = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      displayManager = {                  # called display manager but this is where most lock screen config is
        lightdm = {
          enable = true;
          greeters.slick = {
            enable = true;
            extraConfig = "background=./ships.jpg";
          };
        };
        defaultSession = "xfce+i3";
      };
    };
    gvfs.enable  = true;
    gnome.gnome-keyring.enable = true;
    blueman.enable = true;  
    pipewire = {
      enable = true;
      alsa =  {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };
  
  programs = {
    zsh.enable = true;
    thunar.enable = true;
    dconf.enable =  true;
#    zoxide = {
#    enable = true;
#    enableZshIntegration =  true;
#      };
    };

  programs.zsh  = {
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histSize = 3000;
    enableLsColors = true;
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jangove = {
    isNormalUser = true;
    description = "Jarrod Angove";
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  fonts.packages = with pkgs; [
    nerdfonts
    jetbrains-mono
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

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after =  ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = 
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
    };
  };

  hardware = {
    bluetooth.enable = true;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
