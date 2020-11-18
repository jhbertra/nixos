{config, pkgs, ...}:

let
  hook = shell: "eval \"$(${pkgs.direnv}/bin/direnv hook ${shell})\"";
in {
  environment.systemPackages = [ pkgs.direnv pkgs.lorri ];
  programs.bash.interactiveShellInit =  hook "bash";
  programs.zsh.interactiveShellInit =  hook "zsh";
  services.lorri.enable = true;
}
