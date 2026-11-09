{ pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "minecraft-server"
  ];

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers = {
      fabricLatest = {
        enable = true;
        autoStart = false;
        package = pkgs.fabricServers.fabric;
        jvmOpts = "-Xms8192M -Xmx8192M";
        openFirewall = true;
      };

      create-aeronautics = {
        enable = true;
        autoStart = false;
        package = pkgs.neoforgeServers.neoforge-1_21_1; 

        serverProperties = {
          server-port = 25565;
          motd = "Create Aeronautics Server";
          difficulty = "normal";
          gamemode = "survival";
          level-seed = "1638";
          allow-flight = true;
          white-list = true;
          enforce-whitelist = true;
        };
      };
    };
  };
}
