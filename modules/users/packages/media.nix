{ pkgs, ... }:
{
  users.users.tom.packages = with pkgs; [
    # Audio playback & control
    mpv
    mpg123
    playerctl
    pamixer
    youtube-music

    # Audio routing
    pavucontrol
    pwvucontrol
    qpwgraph

    # Video recording & editing
    obs-studio
    wf-recorder
    video-trimmer
    ffmpeg_7
    streamcontroller

    # Image editing
    pinta
    imagemagick
  ];
}
