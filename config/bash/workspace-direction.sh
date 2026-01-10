 (writeShellScriptBin "workspace-direction" ''
      sorted=$(hyprctl monitors -j | jq "sort_by(.x) | map(.name)")
      len=$(echo $sorted | jq length)
      activeIndex=$(echo $sorted | jq "index($(hyprctl activeworkspace -j | jq .monitor))")
      next=$((($activeIndex $1 1) % $len))
      nextName=$(echo $sorted | jq ".[$next]")

      hyprctl dispatch workspace $(hyprctl monitors -j | jq "map(select(.name == $nextName)) | .[0] | .activeWorkspace.id")
    '')