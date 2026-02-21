{ pkgs, ... }:
{
  users.users.tom.packages = with pkgs; [
    # Editors
    vscodium
    kdePackages.kate
    codebuff

    # JetBrains
    jetbrains.idea
    jetbrains.rider

    # Build tools
    git
    cmake
    libgcc
    gettext
    extra-cmake-modules
    linuxHeaders
    glibc

    # .NET
    dotnet-sdk_8
    dotnet-sdk_9
    mono
    ilspycmd

    # Languages & runtimes
    python311
    jdk21
    nodejs_25
    nodePackages."@angular/cli"

    # CLI dev tools
    jq
  ];
}
