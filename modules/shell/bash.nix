{ self, ... }:
{
  programs.bash.blesh.enable = true;

  programs.bash.interactiveShellInit =
    builtins.readFile "${self}/scripts/yazi-function.sh" + ''
      eval "$(zoxide init --cmd cd bash)"
      eval "$(atuin init bash)"
    '';
}
