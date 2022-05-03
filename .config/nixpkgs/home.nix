{ config, pkgs, ... }:
 let
   unstable = import <nixos-unstable> {};
 in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "zach";
    homeDirectory = "/home/zach";

    # source config files
    file."starship.toml".source = ./starship/starship.toml;
    file.".tmux.conf".source = ./tmux/tmux.conf;
  };

  # enable unFree programs (code, chrome) to be installed
  nixpkgs.config.allowUnfree = true;

  home.packages = [
    # x tools
    pkgs.kitty
    pkgs.google-chrome
    pkgs.vscode

    # Command line tools
    pkgs.git 
    pkgs.mosh
    pkgs.tmux
    pkgs.wget
    unstable.ansible
    unstable.helix
    unstable.starship

    # xmonad stuff
    unstable.rofi

    # faster newer better terminal tools
    unstable.bat
    unstable.exa
    unstable.fd
    unstable.gitui
    unstable.rargs
    unstable.ripgrep

  ];

  programs = {
    home-manager.enable = true;

    #  set fish shell configuration file
    fish = {
      enable = true;
      interactiveShellInit = builtins.readFile ./fish/config.fish;
    };

    # setup my git configurations
    gh.enable = true;
    git = {
      enable= true;
      userName = "zachthieme";
      userEmail = "zach@techsage.org";
      aliases = {
        st = "status";
      };
    };

    neovim = {
      package = unstable.neovim-unwrapped;
      enable = true;
      viAlias = true;
      vimAlias = true;
      plugins = with unstable.vimPlugins;
        [
          vim-airline 
          (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars ))
          vim-surround
          auto-pairs
          vim-numbertoggle
          vim-which-key
          vim-smoothie
          nerdtree
          vim-easymotion
#          toggleterm-nvim 
          vim-nix
        ];
       extraConfig = builtins.readFile ./nvim/init.vim;
    };
  };	

  home.stateVersion = "21.11";

  xsession = {
    enable = true;

    windowManager = {
      xmonad = {
        enable = true;  
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          unstable.haskellPackages.xmonad  
          unstable.haskellPackages.xmonad-contrib
          unstable.haskellPackages.xmonad-extras  
        ];
        config = ./xmonad/xmonad.hs;
      };
    }; 			

  };
}
