{ pkgs, self, ... }:
let
  # qBittorrent wrapped so it ALWAYS launches inside the "vpn" network
  qbittorrentVpn = pkgs.symlinkJoin {
    name = "qbittorrent-vpn";
    paths = [ pkgs.qbittorrent ];
    postBuild = ''
      rm "$out/bin/qbittorrent"
      cat > "$out/bin/qbittorrent" <<EOF
#!${pkgs.runtimeShell}
exec /run/current-system/sw/bin/vpn-run ${pkgs.qbittorrent}/bin/qbittorrent "\$@"
EOF
      chmod +x "$out/bin/qbittorrent"

      if [ -e "$out/share/applications/org.qbittorrent.qBittorrent.desktop" ]; then
        rm "$out/share/applications/org.qbittorrent.qBittorrent.desktop"
        substitute \
          "${pkgs.qbittorrent}/share/applications/org.qbittorrent.qBittorrent.desktop" \
          "$out/share/applications/org.qbittorrent.qBittorrent.desktop" \
          --replace-quiet "${pkgs.qbittorrent}/bin/qbittorrent" "$out/bin/qbittorrent" \
          --replace-quiet "Exec=qbittorrent" "Exec=$out/bin/qbittorrent"
      fi
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "vpn-netns-up" (builtins.readFile "${self}/scripts/vpn-netns-up.sh"))
    (writeShellScriptBin "vpn-netns-down" (builtins.readFile "${self}/scripts/vpn-netns-down.sh"))
    (writeShellScriptBin "vpn-run" (builtins.readFile "${self}/scripts/vpn-run.sh"))
    qbittorrentVpn
  ];

  security.sudo.extraRules = [{
    groups = [ "wheel" ];
    commands = [
      { command = "/run/current-system/sw/bin/vpn-netns-up"; options = [ "NOPASSWD" ]; }
      { command = "/run/current-system/sw/bin/vpn-netns-down"; options = [ "NOPASSWD" ]; }
      { command = "/run/current-system/sw/bin/ip"; options = [ "NOPASSWD" ]; }
      { command = "/run/current-system/sw/bin/wg"; options = [ "NOPASSWD" ]; }
      { command = "/run/current-system/sw/bin/cat /run/vpn-netns/active"; options = [ "NOPASSWD" ]; }
    ];
  }];
}
