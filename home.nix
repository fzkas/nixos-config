{ config, pkgs, ... }:
	
{
	home.username = "milan";
	home.homeDirectory = "/home/milan";

	home.stateVersion = "26.05";

	home.packages = with pkgs; [
		ripgrep
		fd
		htop
		ani-cli
		kdePackages.okular
		clock-rs
	];

	programs.git = {
		enable = true;
		settings.user.name = "fzkas";
		settings.user.email = "mfazekas85@gmail.com";
	};
	
	programs.bash.shellAliases = {
		rebuild = "git -C ~/nixos-config add . && doas nixos-rebuild switch --flake ~/nixos-config#nixos-btw";
		};

	home.file.".xinitrc" = {
		executable = true;
		text = ''
		#!${pkgs.runtimeShell}
		 
		feh --bg-fill /home/milan/Pictures/wallpapers/nixos1.png &
		setxkbmap -option caps:escape
		xset s 300 5
		xss-lock -n /run/current-system/dw/bin/true -- slock &
		xset dpms 0 0 360
		slstatus &
		exec dwm
	'';
};

	programs.home-manager.enable = true;
}
