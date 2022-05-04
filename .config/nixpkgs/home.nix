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
    file."key_bindings.ron".source = ./gitui/key_bindings.ron;
    file."config.toml".source = ./helix/config.toml;
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
    unstable.comma
    unstable.helix
    unstable.nix-index
    unstable.starship
    unstable.yad

    # faster newer better terminal tools
    unstable.ansible
    unstable.bat
    unstable.exa
    unstable.fd
    unstable.gitui
    unstable.rargs
    unstable.ripgrep
    unstable.rage
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

    rofi = {
      enable = true;
      package = unstable.rofi;
      terminal = "${pkgs.kitty}/bin/kitty";
#      theme = ./rofi/theme.rafi;
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
