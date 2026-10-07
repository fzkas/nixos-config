{ config, pkgs, ... }:
	
{
	home.username = "milan";
	home.homeDirectory = "/home/milan";

	home.stateVersion = "26.05";

	home.packages = with pkgs; [
		ripgrep
		fd
		htop
	];

	programs.git = {
		enable = true;
		settings.user.name = "fzkas";
		settings.user.email = "mfazekas85@gmail.com";
	};

#	home.file.".xinitrc".text = ''
#		slstatus &
#		exec dwm
#	'';

	programs.home-manager.enable = true;
}
