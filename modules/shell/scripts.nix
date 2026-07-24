{ pkgs, self, ... }:
{
  environment.systemPackages = with pkgs; [
    (yazi.override {
      _7zz = _7zz-rar;
    })
    (writeShellScriptBin "mc" (builtins.readFile "${self}/scripts/mc.sh"))
    (writeShellScriptBin "vpn" (builtins.readFile "${self}/scripts/vpn.sh"))
    (writeShellScriptBin "workspace-direction" (builtins.readFile "${self}/scripts/workspace-direction.sh"))
    (writeShellScriptBin "wanikani-launch" (builtins.readFile "${self}/scripts/wanikani-launch.sh"))
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
    (writeShellScriptBin "ClashOfClans" "waydroid app launch com.supercell.clashofclans")
    (writeShellScriptBin "Holodori" "waydroid app launch game.qualiarts.hololive.dreams.com")
    (writeShellScriptBin "autoclicker" ''while true; do ydotool click 0xC0; sleep "$1"; done'')
  ];
}
