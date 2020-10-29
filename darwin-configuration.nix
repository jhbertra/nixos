{ config, lib, pkgs, ... }:

{
  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
  system.defaults.NSGlobalDomain._HIHideMenuBar = true;

  system.defaults.dock.autohide = true;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.showhidden = false;

  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.finder.FXEnableExtensionChangeWarning = true;

  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.TrackpadThreeFingerDrag = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ config.programs.vim.package

      pkgs.ctags
      pkgs.curl
      pkgs.direnv
      pkgs.entr
      pkgs.fzf
      pkgs.git
      pkgs.htop
      pkgs.jq
      pkgs.ripgrep
      pkgs.shellcheck
      
      pkgs.darwin-zsh-completions
    ];

  services.yabai.enable = true;
  services.yabai.package = pkgs.yabai;
  services.yabai.enableScriptingAddition = true;
  services.yabai.extraConfig = ''
    yabai -m config mouse_follows_focus           off
    yabai -m config focus_follows_mouse           off
    yabai -m config window_placement              second_child
    yabai -m config window_topmost                off
    yabai -m config window_opacity                on
    yabai -m config window_opacity_duration       0.0
    yabai -m config window_shadow                 on
    yabai -m config window_border                 off
    yabai -m config active_window_opacity         1.0
    yabai -m config normal_window_opacity         0.85
    yabai -m config split_ratio                   0.62
    yabai -m config auto_balance                  off

    yabai -m config layout                        bsp
    yabai -m config top_padding                   0
    yabai -m config bottom_padding                0
    yabai -m config left_padding                  0
    yabai -m config right_padding                 0
    yabai -m config window_gap                    0

    yabai -m rule --add app="emacs"               manage="on"
    yabai -m rule --add app="Dash"                manage="off"
    yabai -m rule --add app="System Preferences"  manage="off"
  '';

  services.skhd.enable = true;
  services.skhd.package =  pkgs.skhd;
  services.skhd.skhdConfig = let
    modMask = "cmd";
    moveMask = "ctrl + cmd";
    myBrowser = "open /Applications/Brave\ Browser.app";
    noop = "/dev/null";
    prefix = "${pkgs.yabai}/bin/yabai -m";
    fstOrSnd = {fst, snd}: domain: "${prefix} ${domain} --focus ${fst} || ${prefix} ${domain} --focus ${snd}";
    nextOrFirst = fstOrSnd { fst = "next"; snd = "first";};
    prevOrLast = fstOrSnd { fst = "prev"; snd = "last";};
  in ''
    # windows ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
    # select
    ${modMask} - j                            : ${prefix} window --focus next || ${prefix} window --focus "$((${prefix} query --spaces --display next || ${prefix} query --spaces --display first) |${pkgs.jq}/bin/jq -re '.[] | select(.visible == 1)."first-window"')" || ${prefix} display --focus next || ${prefix} display --focus first
    ${modMask} - k                            : ${prefix} window --focus prev || ${prefix} window --focus "$((yabai -m query --spaces --display prev || ${prefix} query --spaces --display last) | ${pkgs.jq}/bin/jq -re '.[] | select(.visible == 1)."last-window"')" || ${prefix} display --focus prev || ${prefix} display --focus last

    # close
    ${modMask} - 0x33: ${prefix} window --close && yabai -m window --focus prev

    # fullscreen
    ${modMask} - h                            : ${prefix} window --toggle zoom-fullscreen

    # rotate
    ${modMask} - r                            : ${prefix} window --focus smallest && yabai -m window --warp largest && yabai -m window --focus largest

    # increase region
    ${modMask} - 0x21                         : ${prefix} window --resize left:-20:0
    ${modMask} - 0x1E                         : ${prefix} window --resize right:-20:0
    
    # spaces ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
    # switch 
    ${modMask} + alt - j                      : ${prevOrLast "space"}
    ${modMask} + alt - k                      : ${nextOrFirst "space"}

    # send window 
    ${modMask} + ${moveMask} - j              : ${prefix} window --space prev
    ${modMask} + ${moveMask} - k              : ${prefix} window --space next

    # display  ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
    # focus 
    ${modMask} - left                         : ${prevOrLast "display"}
    ${modMask} - right                        : ${nextOrFirst "display"}

    # send window
    ${moveMask} - right                       : ${prefix} window --display prev
    ${moveMask} - left                        : ${prefix} window --display next

    # apps  ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
    ${modMask} - b                            : ${myBrowser}

    # reset  ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
    ${modMask} - q                            : pkill yabai; pkill skhd; osascript -e 'display notification "wm restarted"'
  '';

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix.extraOptions = ''
    gc-keep-derivations = true
    gc-keep-outputs = true
    min-free = 17179870000
    max-free = 17179870000
    log-lines = 128
  '';

  programs.nix-index.enable = true;

  programs.tmux.enable = true;
  programs.tmux.enableSensible = true;
  programs.tmux.enableMouse = true;
  programs.tmux.enableFzf = true;
  programs.tmux.enableVim = true;

  programs.vim.package = pkgs.neovim.override {
    configure = {
      packages.darwin.start = with pkgs.vimPlugins;
        let
          vim-textobj-entire = pkgs.vimUtils.buildVimPluginFrom2Nix {
            name = "vim-textobj-entire";
            src = pkgs.fetchFromGitHub {
              owner = "kana";
              repo = "vim-textobj-entire";
              rev = "64a856c9dff3425ed8a863b9ec0a21dbaee6fb3a";
              sha256 = "0kv0s85wbcxn9hrvml4hdzbpf49b1wwr3nk6gsz3p5rvfs6fbvmm";
            };
          };
          vim-textobj-line = pkgs.vimUtils.buildVimPluginFrom2Nix {
            name = "vim-textobj-line";
            src = pkgs.fetchFromGitHub {
              owner = "kana";
              repo = "vim-textobj-line";
              rev = "0a78169a33c7ea7718b9fa0fad63c11c04727291";
              sha256 = "0mppgcmb83wpvn33vadk0wq6w6pg9cq37818d1alk6ka0fdj7ack";
            };
          };
        in
          [
            ReplaceWithRegister
            ale
            deoplete-nvim
            fzfWrapper
            polyglot
            targets-vim
            ultisnips
            vim-abolish
            vim-airline
            vim-commentary
            vim-exchange
            vim-gutentags
            vim-indent-object
            vim-repeat
            vim-sensible
            vim-sort-motion
            vim-surround
            vim-textobj-entire
            vim-textobj-line
            vim-textobj-user
            vim-unimpaired
          ];
    };
  };

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.bash.enableCompletion = true;
  programs.zsh.enable = true;
  programs.zsh.enableBashCompletion = true;
  programs.zsh.enableFzfCompletion = true;
  programs.zsh.enableFzfGit = true;
  programs.zsh.enableFzfHistory = true;
  programs.zsh.variables.cfg = "$HOME/.config/nixpkgs/darwin/configuration.nix";
  programs.zsh.variables.darwin = "$HOME/.nix-defexpr/darwin";
  programs.zsh.variables.nixpkgs = "$HOME/.nix-defexpr/nixpkgs";
  
  environment.loginShell = "${pkgs.zsh}/bin/zsh -l";
  environment.variables.SHELL = "${pkgs.zsh}/bin/zsh";

  environment.variables.LANG = "en_US.UTF-8";
  
  environment.shellAliases.g = "git log --pretty=color -32";
  environment.shellAliases.gb = "git branch";
  environment.shellAliases.gc = "git checkout";
  environment.shellAliases.gcb = "git checkout -B";
  environment.shellAliases.gd = "git diff --minimal --patch";
  environment.shellAliases.gf = "git fetch";
  environment.shellAliases.ga = "git log --pretty=color --all";
  environment.shellAliases.gg = "git log --pretty=color --graph";
  environment.shellAliases.gl= "git log --pretty=nocolor";
  environment.shellAliases.grh= "git reset --hard";
  environment.shellAliases.l= "ls -lh";

  nixpkgs.overlays = [
    (self: super: {
      darwin-zsh-completions = super.runCommandNoCC "darwin-zsh-completions-0.0.0"
        { preferLocalBuild = true; }
        ''
          mkdir -p $out/share/zsh/site-functions
          cat <<-'EOF' > $out/share/zsh/site-functions/_darwin-rebuild
          #compdef darwin-rebuild
          #autoload
          _nix-common-options
          local -a _1st_arguments
          _1st_arguments=(
            'switch:Build, activate, and update the current generation'\
            'build:Build without activating or updating the current generation'\
            'check:Build and run the activation sanity checks'\
            'changelog:Show most recent entries in the changelog'\
          )
          _arguments \
            '--list-generations[Print a list of all generations in the active profile]'\
            '--rollback[Roll back to the previous configuration]'\
            {--switch-generation,-G}'[Activate specified generation]'\
            '(--profile-name -p)'{--profile-name,-p}'[Profile to use to track current and previous system configurations]:Profile:_nix_profiles'\
            '1:: :->subcmds' && return 0
          case $state in
            subcmds)
              _describe -t commands 'darwin-rebuild subcommands' _1st_arguments
            ;;
          esac
          EOF
        '';

      vim_configurable = super.vim_configurable.override {
        guiSupport = "no";
      };
    })
  ];

  users.nix.configureBuildUsers = true;
  users.nix.nrBuildUsers = 32;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
