{ config, pkgs, ... }:

{
    programs.bash = {
        enable = true;
        enableCompletion = true;
        shellAliases = {
            ls = "eza --group-directories-first";
        };
        initExtra =
        ''
            export PS1="[\[$(tput setaf 27)\]\u\[$(tput setaf 135)\]@\[$(tput setaf 45)\]\h:\[$(tput setaf 33)\]\w] \[$(tput sgr0)\]$ "

        '';
    };
    programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        defaultEditor = true;
    };

    dconf.enable = true;
    dconf.settings = {
        "org/gnome/desktop/datetime".automatic-timezone = true;
        "org/gnome/desktop/interface".clock-format = "12h";
        "org/gnome/desktop/interface".enable-hot-corners = true;
        "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
        "org/gnome/desktop/search-providers".enabled = "['org.gnome.Calendar.desktop', 'org.gnome.Weather.desktop', 'org.gnome.Contacts.desktop', 'org.gnome.Calculator.desktop', 'org.gnome.Characters.desktop', 'org.gnome.clocks.desktop']";
        "org/gnome/desktop/wm/preferences".auto-raise = true;
        "org/gnome/mutter".dynamic-workspaces = true;
        "org/gnome/mutter".edge-tiling = true;
        "org/gnome/shell/extensions/blur-my-shell/overview".style-components = 3;
        "org/gnome/shell/extensions/blur-my-shell/panel".blur = false;
        "org/gnome/shell/extensions/blur-my-shell/panel".customize = true;
        "org/gnome/shell/extensions/blur-my-shell/panel".style-panel = 0;
        "org/gnome/shell/extensions/blur-my-shell/panel".override-background = false;
        "org/gnome/shell/extensions/blur-my-shell/panel".override-background-dynamically = false;
        "org/gnome/shell/extensions/blur-my-shell/panel".unblur-in-overview = true;
        "org/gnome/system/location".enabled = true;
        "org/gtk/gtk4/settings/file-chooser".sort-directories-first = true;
        "org/gtk/settings/file-chooser".sort-directories-first = true;
        "org/gnome/shell".enabled-extensions = [
            "appindicatorsupport@rgcjonas.gmail.com"
            "blur-my-shell@aunetx"
            "gsconnect@andyholmes.github.io"
            "nightthemeswitcher@romainvigier.fr"
            "noannoyance-fork@vrba.dev"
            "tailscale-status@maxgallup.github.com"
            "tiling-assistant@leleat-on-github"
            "drive-menu@gnome-shell-extensions.gcampax.github.com"
            "light-style@gnome-shell-extensions.gcampax.github.com"
        ];
        "org/virt-manager/virt-manager/connections" = {
            autoconnect = ["qemu:///system"];  
            uris = ["qemu:///system"];
        };
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