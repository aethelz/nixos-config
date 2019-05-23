pkgs:
{
  home.file = {
    # ".config/nvim/init.vim".source = "${builtins.fetchGit {
    #   url = "https://github.com/aethelz/dotfiles/";
    # }}/nvim/.config/nvim/init.vim";
    ".local/share/nvim/site/autoload/plug.vim".source = "${builtins.fetchGit {
      url = "https://github.com/junegunn/vim-plug/";
    }}/plug.vim";
    ".config/ranger/rc.conf".source = "${builtins.fetchGit {
      url = "https://github.com/aethelz/dotfiles/";
    }}/ranger/.config/ranger/rc.conf";
    ".config/termite/config".source = "${builtins.fetchGit {
      url = "https://github.com/aethelz/dotfiles/";
    }}/termite/.config/termite/config";
    ".Xmodmap".source = "${builtins.fetchGit {
      url = "https://github.com/aethelz/dotfiles/";
    }}/xmodmap/.Xmodmap";
    ".config/acer.icm".source = "${builtins.fetchGit {
      url = "https://github.com/aethelz/dotfiles/";
    }}/color/acer.icm";
    ".config/i3/config".source = "${builtins.fetchGit {
      url = "https://github.com/aethelz/dotfiles/";
    }}/i3/.config/i3/config";
    ".moc/" = {
      source = "${builtins.fetchGit {
        url = "https://github.com/aethelz/dotfiles/";
      }}/moc/.moc/";
      recursive = true;
    };
    ".config/mpv/mpv.conf".source = "${builtins.fetchGit {
      url = "https://github.com/aethelz/dotfiles/";
    }}/mpv/.config/mpv/mpv.conf";
  };
  home.packages = [ pkgs.atool ];
  #pkgs.brightnessctl pkgs.chromium pkgs.gnupg

  programs = {
    zathura.enable = true;
    firefox.enable = true;
    chromium.enable = true;
    fzf.enable = true;
    fzf.defaultCommand = "rg --files";
    # neovim.package = myNVimBundle;
    neovim.enable = true;
    neovim.vimAlias = true;
    neovim.viAlias = true;
  ##neovim.configure = {
  ##  packages.myVimPackage = with pkgs.vimPlugins; {
  ##    start = [
  ##      fzfWrapper
  ##    ];
  ##  };
  ##};
    bash = {
      enable = true;
      shellAliases = {
        dir = "exa --long --git --all";
      };
      shellOptions = [ "autocd" ];
      historyControl = [
        "erasedups"
        "ignoredups"
      ];
      historyIgnore = [ "cd" ];
      bashrcExtra = ''
        export EDITOR="nvim"
        export PS1="\[\e[0;30m\e[44m\]\u@\h:\w\$\[\e[0m\] "
        rg() {
        if [ -z "$RANGER_LEVEL" ]
        then
        ranger
        else
        exit
        fi
        }
        [ -n "$RANGER_LEVEL" ] && PS1="$PS1"'(in ranger) '
        bind '"\e[A": history-search-backward'
        bind '"\e[B": history-search-forward'
      '';
    };
  };
}
