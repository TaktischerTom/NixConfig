{ ... }:
{
  environment.shellAliases = {
    ns = "nh os switch";
    nb = "nh os boot";
    nu = "nix flake update --flake /home/tom/SystemConfig/ --commit-lock-file";
    sys = "codium ~/SystemConfig";
  };
}
