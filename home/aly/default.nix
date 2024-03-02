{ config, pkgs, ... }:

{
    # TODO please change the username & home directory to your own
    home.username = "aly";
    home.homeDirectory = "/home/aly";

    services.syncthing.enable = true;

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
	    vscode
        curl
        distrobox
        eza # A modern replacement for ‘ls’
        fzf # A command-line fuzzy finder
        git
        nnn # terminal file manager
        wget
        syncthing
    ];

    # basic configuration of git, please change to your own
    programs.git = {
        enable = true;
        userName = "Aly Raffauf";
        userEmail = "alyraffauf@gmail.com";
    };

    programs.bash = {
        enable = true;
        enableCompletion = true;
        shellAliases = {
            ls = "eza --group-directories-first";
        };
    };

    # programs.vscode = {
    #     enable = false;
    #     userSettings = {
    #         "update.mode" = "none";
    #         "window.autoDetectColorScheme" = true;
    #         "window.titleBarStyle" = "custom";
    #         "workbench.colorTheme" = "Light Modern";
    #     };
    #     enableUpdateCheck = false;
    # };

    programs.vim.enable = true;

    dconf = {
        enable = true;
        settings."org/gnome/desktop/datetime".automatic-timezone = true;
        settings."org/gnome/desktop/interface".clock-format = "12h";
        settings."org/gnome/desktop/interface".enable-hot-corners = true;
        settings."org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
        settings."org/gnome/desktop/search-providers".enabled = "['org.gnome.Calendar.desktop', 'org.gnome.Weather.desktop', 'org.gnome.Contacts.desktop', 'org.gnome.Calculator.desktop', 'org.gnome.Characters.desktop', 'org.gnome.clocks.desktop']";
        settings."org/gnome/desktop/wm/preferences".auto-raise = true;
        settings."org/gnome/mutter".dynamic-workspaces = true;
        settings."org/gnome/mutter".edge-tiling = true;
        settings."org/gnome/settings-daemon/plugins/color".night-light-enabled = true;
        settings."org/gnome/shell/extensions/blur-my-shell/overview".style-components = 3;
        settings."org/gnome/shell/extensions/blur-my-shell/panel".blur = false;
        settings."org/gnome/shell/extensions/blur-my-shell/panel".customize = true;
        settings."org/gnome/shell/extensions/blur-my-shell/panel".style-panel = 0;
        settings."org/gnome/shell/extensions/blur-my-shell/panel".override-background = true;
        settings."org/gnome/shell/extensions/blur-my-shell/panel".override-background-dynamically = true;
        settings."org/gnome/shell/extensions/blur-my-shell/panel".unblur-in-overview = true;
        settings."org/gnome/system/location".enabled = true;
        settings."org/gtk/gtk4/settings/file-chooser".sort-directories-first = true;
        settings."org/gtk/settings/file-chooser".sort-directories-first = true;
        settings."org/gnome/shell".enabled-extensions = [
            "appindicatorsupport@rgcjonas.gmail.com"
            "blur-my-shell@aunetx"
            "gsconnect@andyholmes.github.io"
            "nightthemeswitcher@romainvigier.fr"
            "noannoyance-fork@vrba.dev"
            "tailscale-status@maxgallup.github.com"
            "tiling-assistant@leleat-on-github"
            "drive-menu@gnome-shell-extensions.gcampax.github.com"
          ];
        };
    # This value determines the home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update home Manager without changing this value. See
    # the home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "23.11";

    # Let home Manager install and manage itself.
    programs.home-manager.enable = true;
}
