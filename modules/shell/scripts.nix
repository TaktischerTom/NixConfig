{ pkgs, self, ... }:
{
  environment.systemPackages = with pkgs; [
    (yazi.override {
      _7zz = _7zz-rar;
    })
    (writeShellScriptBin "mc" (builtins.readFile "${self}/scripts/mc.sh"))
    (writeShellScriptBin "workspace-direction" (builtins.readFile "${self}/scripts/workspace-direction.sh"))
    (writeShellScriptBin "protonhax" (builtins.readFile "${self}/scripts/protonhax.sh"))
    (writeShellScriptBin "tomp4" (builtins.readFile "${self}/scripts/tomp4.sh"))
    (writeShellScriptBin "clipper" (builtins.readFile "${self}/scripts/clipper.sh"))
    (writeShellScriptBin "warframe" (builtins.readFile "${self}/scripts/warframe.sh"))
    (writeShellScriptBin "Guild_Wars_2" (builtins.readFile "${self}/scripts/guildwars2.sh"))
    (writeShellScriptBin "nintendo" "desmume")
    (writeShellScriptBin "audio" "qpwgraph")
    (writeShellScriptBin "kon" "foot")
    (writeShellScriptBin "steamConsole" "steam -console")
    (writeShellScriptBin "pass" "keepassxc")
    (writeShellScriptBin "arknights" "waydroid app launch com.YoStarEN.Arknights")
    (writeShellScriptBin "playStore" "waydroid app launch com.android.vending")
  ];
}
