{ config, pkgs, ... }:

{
  environment.variables.EDITOR = "${config.programs.vim}/bin/nvim";

  environment.systemPackages = [
    config.programs.vim.package
    ctags
  ];

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

  environment.shellAliases = {
    vim = "${config.programs.vim}/bin/nvim";
    e   = "${config.programs.vim}/bin/nvim";
  };
}
