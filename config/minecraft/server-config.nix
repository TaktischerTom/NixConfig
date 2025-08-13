{
  enable = true;
  eula = true;

  servers = {
    fabricLatest = {
      enable = true;
      autoStart = false;
      package = pkgs.fabricServers.fabric;
      jvmOpts = "-Xms8192M -Xmx8192M";
      op
    };
  };
}