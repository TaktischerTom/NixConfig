# Tom's NixOS Configuration

A fully declarative [NixOS](https://nixos.org/) system configuration managed as a [Nix Flake](https://wiki.nixos.org/wiki/Flakes).
Originally a single monolithic file, it has been restructured into a modular architecture

| Detail | Value |
|---|---|
| **Hostname** | `nixos` |
| **User** | `tom` |
| **Desktop** | Hyprland (Wayland) |
| **Channel** | `nixpkgs-unstable` |
| **Architecture** | `x86_64-linux` |

---

##  Directory Structure

```
.
├── flake.nix                          # Flake entry point — inputs & outputs
├── flake.lock                         # Pinned dependency versions
├── configuration.nix                  # Import hub
├── hardware-configuration.nix         # DO NOT EDIT
│
├── modules/
│   ├── core/
│   │   ├── default.nix                # Aggregator
│   │   ├── boot.nix                   # systemd-boot, EFI settings, config limit
│   │   ├── networking.nix             # Hostname ("nixos"), NetworkManager
│   │   ├── locale.nix                 # Timezone, i18n, fcitx5 + mozc
│   │   ├── nix-settings.nix           # Flakes
│   │   └── variables.nix              # Custom variables
│   │
│   ├── hardware/
│   │   ├── default.nix                # Aggregator
│   │   ├── bluetooth.nix              # Bluetooth + xpadneo Xbox controller support
│   │   ├── openrazer.nix              # Razer peripheral daemon
│   │   └── udev-rules.nix             # Stream Deck USB/HID udev rules
│   │
│   ├── desktop/
│   │   ├── default.nix                # Aggregator
│   │   ├── hyprland.nix               # Hyprland compositor + UWSM login shell
│   │   ├── wallpapers.nix             # Declarative per-workspace wallpapers (awww renderer)
│   │   ├── fonts.nix                  # Font packages + fontconfig defaults
│   │   └── environment.nix            # X11 keymap, env vars
│   │
│   ├── programs/
│   │   ├── default.nix                # Aggregator
│   │   ├── common.nix                 # duh
│   │   ├── gaming.nix                 # Steam + Proton-GE, Gamemode, Gamescope, AAGL launchers, Minecraft overlay
│   │   └── flatpak.nix                # Flatpak + Flathub repo
│   │
│   ├── services/
│   │   ├── default.nix                # Aggregator
│   │   ├── audio.nix                  # PipeWire
│   │   ├── printing.nix               
│   │   ├── minecraft-server.nix       # Fabric Minecraft server
│   │   └── system.nix                 # systemd timeout tweaks
│   │
│   ├── users/
│   │   ├── packages                   # User packages
│   │   └── default.nix                # Aggregator
│   │
│   └── shell/
│       ├── default.nix                # Aggregator
│       ├── aliases.nix                # Shell aliases
│       ├── scripts.nix                # writeShellScriptBin wrappers for scripts/ + yazi override
│       ├── bash.nix                   # ble.sh, zoxide, atuin, yazi shell function
│       └── symlinks.nix               # Custom 'links' option for activation-time symlinks
│
├── scripts/                           # Pure shell scripts (referenced by modules/shell/scripts.nix)
│   ├── mc.sh                          # Minecraft server management (start / stop / restart / status)
│   ├── protonhax.sh                   # Run commands inside the Proton/Wine context of a running Steam game
│   ├── workspace-direction.sh         # Hyprland: cycle focus between monitors
│   ├── yazi-function.sh               # Yazi file-manager shell integration (cd on exit)
│   ├── guildwars2.sh                  # Launch Guild Wars 2 via Steam
│   ├── warframe.sh                    # Launch Warframe via Steam
│   ├── clipper.sh                     # Video replay clipper (trim + convert to mp4)
│   ├── save.sh                        # Quickshell notification test script
│   ├── wallpaper-per-workspace.sh     # awww driver: one wallpaper per workspace
│   └── tomp4.sh                       # Convert MKV → MP4 (stream copy)
│
└── hypr/                              # Hyprland config
    ├── hyprland.conf                  # Main config — monitors, keybinds, window rules, animations
    ├── hyprland.lua                   # Lua config entry point (Hyprland ≥ 0.55)
    ├── modules/wallpapers.lua         # Fires the per-workspace wallpaper script on workspace/monitor events
    └── xdph.conf                      # xdg-desktop-portal-hyprland config
```

---

## Flake Inputs

| Input | Source | Purpose |
|---|---|---|
| **nixpkgs** | `nixos/nixpkgs` (unstable) | Base package set & NixOS modules |
| **quickshell** | `outfoxxed/quickshell` | Quickshell widget framework |
| **aagl** | `ezKEa/aagl-gtk-on-nix` | Anime game launchers |
| **prismlauncher** | `PrismLauncher/PrismLauncher` | Minecraft launcher (Prism) |
| **nix-minecraft** | `Infinidoge/nix-minecraft` | Declarative Minecraft server management |
| **putah** | `QuetzColito/putah` | Putah utility |


---

## Quick Reference — Shell Aliases

These aliases are defined in `modules/shell/aliases.nix`:

| Alias | Expands to | Description |
|---|---|---|
| `ns` | `nh os switch` | Rebuild the system and **switch** immediately |
| `nb` | `nh os boot` | Rebuild the system for the **next boot** |
| `nu` | `nix flake update --flake /home/tom/SystemConfig/ --commit-lock-file` | **Update** all flake inputs and commit the new lock file |
| `sys` | `codium ~/SystemConfig` | Open this config in **VSCodium** |

---

##  Rebuilding

```bash
# After making changes, rebuild and switch live:
ns

# Or stage the rebuild for the next boot:
nb

# Update all flake inputs first, then rebuild:
nu && nb
```


---

## How It Works

### The Import Chain

```
flake.nix
  ├─► hardware-configuration.nix
  └─► configuration.nix             (import hub + stateVersion)
        ├─► inputs.aagl.nixosModules.default
        ├─► inputs.nix-minecraft.nixosModules.minecraft-servers
        └─► modules/
              ├── core/default.nix     → boot, networking, locale, nix-settings, variables
              ├── hardware/default.nix → bluetooth, openrazer, udev-rules
              ├── desktop/default.nix  → hyprland, fonts, environment
              ├── programs/default.nix → common, gaming, flatpak
              ├── services/default.nix → audio, printing, minecraft-server, system
              ├── users/default.nix    → tom
              └── shell/default.nix    → aliases, scripts, bash, symlinks
```

Each `default.nix` is a simple **aggregator** that imports the sibling files in its directory.

### Custom Options

| Option | Defined in | Default | Usage |
|---|---|---|---|
| `mainUser` | `modules/core/variables.nix` | `"tom"` | Referenced throughout modules via `config.mainUser` |
| `links` | `modules/shell/symlinks.nix` | — | Declarative activation-time symlinks (used for Hyprland config) |
| `desktop.wallpapers.perWorkspace` | `modules/desktop/wallpapers.nix` | — | `"<monitor>:<workspace>"` → wallpaper image, `"<monitor>:*"` for a monitor-wide default |
| `desktop.wallpapers.default` | `modules/desktop/wallpapers.nix` | `null` | Wallpaper for pairs not covered by `perWorkspace` |

---

## Desktop — Hyprland

The system runs the **Hyprland** Wayland compositor.

The Hyprland configuration lives in the `hypr/` directory and is symlinked to `~/.config/hypr/` at activation time.

### Per-workspace wallpapers

Caelestia can only paint one global wallpaper, so its wallpaper painting is off
(`caelestia/shell.json` → `background.wallpaperEnabled = false`) and **awww**
renders a per-workspace image instead: `hypr/modules/wallpapers.lua` re-runs
`wallpaper-per-workspace apply` on every workspace/monitor event, and the script
only touches the monitor whose image actually changed.

The mapping lives in `modules/desktop/wallpapers.nix`:

```nix
"DP-1:1" = ../../assets/wallpaper/one.png;   # monitor "DP-1", workspace 1
"HDMI-A-2:*" = ../../assets/wallpaper/two.png; # every workspace on HDMI-A-2
```

`default` covers anything else. Useful commands:

| Command | Purpose |
|---|---|
| `wallpaper-per-workspace status` | Show the resolved mapping and transition settings |
| `wallpaper-per-workspace resolve <monitor> <workspace>` | Image that would be used |
| `wallpaper-per-workspace apply` | Re-apply everything (also picks up a rebuild inside a running session) |

The lock screen keeps following the focused monitor (`syncCaelestia = true`),
while the colour scheme is left untouched.

---

## Gaming

- **Steam** with Proton-GE via `programs.steam`
- **Gamemode** & **Gamescope** for performance optimisation
- **AAGL** (An Anime Game Launcher) for anime-related game launchers
- **PrismLauncher** for Minecraft (client)
- **Flatpak**

---

## Input Methods

**fcitx5** with the **mozc** engine is configured in `modules/core/locale.nix` for Japanese input alongside the default `en_US.UTF-8` / `de_DE.UTF-8` locale setup.
