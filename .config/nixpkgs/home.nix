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
    file."/home/zach/.config/starship.toml".source = ./starship/starship.toml;
    file."/home/zach/.tmux.conf".source = ./tmux/tmux.conf;
    file."/home/zach/.config/gitui/key_bindings.ron".source = ./gitui/key_bindings.ron;
    file."/home/zach/.config/helix/config.toml".source = ./helix/config.toml;
    file."/home/zach/.config/kitty/kitty.conf".source = ./kitty/kitty.conf;
    file."/home/zach/.config/rofi/spotlight.rasi".source = ./rofi/spotlight.rasi;
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
    unstable.ansible       # used to encrypt/decrypt secrets 
    unstable.autojump      # used to move between directories fast
    unstable.helix         # fun vim/kakoune style editor with sane defaults
    unstable.nix-tree      # check dependency tree for nix packages
    unstable.starship      # rust based shell prompt that is pretty

    # development tools
    unstable.yarn

    # depoloyment tools
    unstable.nixops

    # needed for my polybar configs
#    unstable.polybar
    unstable.yad

    # needed to install comma which allows us to run commands that aren't on our machine
    unstable.comma         
    unstable.nix-index     # builds indext so comma can find commands

    # needed for qmk
    unstable.docker

    # faster newer better terminal tools
    unstable.bat           # improved cat
    unstable.exa           # improved ls
    unstable.fd            # improved find
    unstable.gitui
    unstable.rargs         # similar to xargs
    unstable.ripgrep       # improved grep
  ];

  programs = {
    home-manager.enable = true;

    # set autojump config
    autojump.enableFishIntegration = true;

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
          vim-lsp
          nvim-lspconfig
        ];
       extraConfig = builtins.readFile ./nvim/init.vim;
    };

    rofi = {
      enable = true;
      package = unstable.rofi;
      terminal = "${pkgs.kitty}/bin/kitty";
      theme = ./rofi/spotlight.rasi;
    };
  };	

  home.stateVersion = "21.11";

  xsession = {
    enable = true;

#    initExtra = polybarOpts;

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

#   services.polybar = {
#     enable = true;
# #    package = mypolybar;
#     config = /home/zach/.config/nixpkgs/polybar/config;
# #    extraConfig = bars + colors + mods1 + mods2 + customMods;
#     script = ''
#       polybar & disown 
#     '';
#   };
}
