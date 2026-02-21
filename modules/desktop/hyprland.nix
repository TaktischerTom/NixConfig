{ ... }:
{
  programs.hyprland.enable = true;

  environment.loginShellInit = ''
    if uwsm check may-start; then
        start-hyprland
    fi
  '';
}
