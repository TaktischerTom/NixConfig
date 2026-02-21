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
│   └── tomp4.sh                       # Convert MKV → MP4 (stream copy)
│
└── hypr/                              # Hyprland config
    ├── hyprland.conf                  # Main config — monitors, keybinds, window rules, animations
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

---

## Desktop — Hyprland

The system runs the **Hyprland** Wayland compositor.

The Hyprland configuration lives in the `hypr/` directory and is symlinked to `~/.config/hypr/` at activation time.

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
