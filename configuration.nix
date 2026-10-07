# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Flakes
	
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Power Manager

	services.thermald.enable = true;

	services.power-profiles-daemon.enable = false;
	services.tlp = {
		enable = true;
		settings = {
			CPU_SCALING_GOVERNOR_ON_AC = "performance";
			CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
			CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
			CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
			CPU_BOOST_ON_BAT = 0;
			PLATFORM_PROFILE_ON_BAT = "low-power";
			};
	};

  # Bootloader
  	boot.loader.systemd-boot.enable = true;
  	boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  	networking.hostName = "nixos-btw"; # Define your hostname.

  # Network
  	networking.networkmanager.enable = false;
	networking.wireless.enable = false;
	networking.useDHCP = false;
	networking.wireless.iwd = {
		enable = true;
		settings = {
			General.EnableNetworkConfiguration = true;
			Settings.AutoConnect = true;
			};
		};
	services.resolved.enable = true;

  # Unused Services
	services.printing.enable = false;
	services.avahi.enable = false;
	services.udisks2.enable = false;
	hardware.bluetooth.enable = false;

  # Set your time zone.
  	time.timeZone = "Europe/Budapest";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
	services.xserver.displayManager.startx.enable = true;
  	services.xserver.enable = true;
		services.xserver.windowManager.dwm = {
			enable = true;
			package = pkgs.dwm.overrideAttrs {
				src = ./suckless/dwm;
			};
		};

  # Terminal Startup
	programs.bash.interactiveShellInit = ''
		fastfetch
	'';
 
  # Aliases
	environment.shellAliases = {
		cdwm = "vim ~/suckless/dwm/config.h";
	};
	
  # Wallpapers
	services.xserver.displayManager.sessionCommands = ''
		${pkgs.feh}/bin/feh --bg-fill /home/milan/Pictures/wallpapers/nixos1.png & 
		'';

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Privileges
	security.doas.enable = true;
	security.doas.extraRules = [
		{
		users = [ "milan" ];
		keepEnv = true;
		persist = true;
		}
	];
	security.sudo.enable = false;	

  # User Account
	users.users.milan = {
		isNormalUser = true;
     		extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     		packages = with pkgs; [
       			tree
     		];
   	};

  # Unfree Package License
	nixpkgs.config.allowUnfree = true;

  # Polkit 
	security.polkit.enable = true;
  # System Packages
   	environment.systemPackages = with pkgs; [
		(pkgs.st.overrideAttrs { src = ./suckless/st; })
		(pkgs.dmenu.overrideAttrs { src = ./suckless/dmenu; })
		(pkgs.slstatus.overrideAttrs { src = ./suckless/slstatus; })
		#(pkgs.ani-cli.overrideAttrs { src = ./ani-cli; })
		vim
		neovim
     		wget
		fastfetch
		git
		librewolf
		zathura
		st
		dmenu
		slstatus
		xterm
		jetbrains-mono
		gnumake
		gcc
		feh
		xdg-user-dirs
		j4-dmenu-desktop
		picom
		cmatrix
		pipes
		asciiquarium
		libxcvt
		btop
		brightnessctl
		xss-lock
		libreoffice
		obsidian
		qutebrowser
		brave
		codeblocks
		gnused
		gnugrep
		yt-dlp
		mpv
		nnn
		pcmanfm
		gruvbox-dark-gtk
		gruvbox-dark-icons-gtk
		lxappearance
		ly
		xauth
		cmus
		vitetris
		lavat	
		bat
		mupdf
		
		# Lazyvim
		gcc
		tree-sitter
		nodejs
		unzip
		curl
		wget
		ripgrep
		fd
		fzf
		lazygit
   	];

  # Fonts
	fonts.packages = with pkgs; [
		nerd-fonts.jetbrains-mono
		jetbrains-mono
	 ];

	#services.displayManager.ly.enable = true;
	

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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}

