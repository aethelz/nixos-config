pkgs:
{
  home.file = {

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

    ".gitconfig".source = "${builtins.fetchGit {
      url = "https://github.com/aethelz/dotfiles/";
    }}/git/.gitconfig";

  };
  home.packages = [
    pkgs.atool
    pkgs.brightnessctl

    pkgs.nodejs-12_x
    pkgs.nodePackages.javascript-typescript-langserver
    pkgs.nodePackages.typescript-language-server
    pkgs.nodePackages.eslint

    pkgs.stack
    pkgs.haskellPackages.ghcid
    pkgs.cabal-install

    pkgs.dhall
    pkgs.docker-compose
    pkgs.font-manager
    pkgs.vscodium
  ];

  programs = {
    zathura.enable = true;
    firefox = {
      enable = true;
      package = pkgs.unstable.firefox-unwrapped;
    };
    chromium.enable = true;
    chromium.package = pkgs.unstable.chromium;
    fzf = {
      enable = true;
      defaultCommand = "rg --files --no-ignore-vcs";
    };
    neovim = {
      enable = true;
      package = pkgs.unstable.neovim-unwrapped;
      plugins = with pkgs.vimPlugins; [
        fzfWrapper
        coc-nvim
      ];
      extraConfig = builtins.readFile "/home/gene/.config/nvim/init.vim";
      vimAlias = true;
      viAlias = true;
      withNodeJs = true;
    };

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
