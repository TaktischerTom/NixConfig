# 🐧 Tom's NixOS Configuration

A fully declarative [NixOS](https://nixos.org/) system configuration managed as a [Nix Flake](https://wiki.nixos.org/wiki/Flakes).
Originally a single monolithic file, it has been restructured into a **modular architecture** — every concern lives in its own module, making the system easy to understand, maintain, and extend.

| Detail | Value |
|---|---|
| **Hostname** | `nixos` |
| **User** | `tom` |
| **Desktop** | Hyprland (Wayland) — 3 monitors |
| **Channel** | `nixpkgs-unstable` |
| **State version** | `25.05` |
| **Architecture** | `x86_64-linux` |

---

## 📂 Directory Structure

```
.
├── flake.nix                          # Flake entry point — inputs & outputs
├── flake.lock                         # Pinned dependency versions (auto-managed)
├── configuration.nix                  # Slim import hub — pulls in every module + sets stateVersion
├── hardware-configuration.nix         # Auto-generated hardware config (DO NOT EDIT)
│
├── modules/
│   ├── core/
│   │   ├── default.nix                # Aggregator — imports all core modules
│   │   ├── boot.nix                   # systemd-boot, EFI settings, config limit
│   │   ├── networking.nix             # Hostname ("nixos"), NetworkManager
│   │   ├── locale.nix                 # Timezone (Europe/Berlin), i18n (en_US / de_DE), fcitx5 + mozc (Japanese input)
│   │   ├── nix-settings.nix           # Flakes & experimental features, allowUnfree, nh garbage collection
│   │   └── variables.nix              # Custom NixOS option: mainUser (default: "tom")
│   │
│   ├── hardware/
│   │   ├── default.nix                # Aggregator
│   │   ├── bluetooth.nix              # Bluetooth + xpadneo Xbox controller support
│   │   ├── openrazer.nix              # Razer peripheral daemon
│   │   └── udev-rules.nix            # Stream Deck USB/HID udev rules
│   │
│   ├── desktop/
│   │   ├── default.nix                # Aggregator
│   │   ├── hyprland.nix               # Hyprland compositor + UWSM login shell
│   │   ├── fonts.nix                  # Font packages (Roboto, Noto, Nerd Fonts) + fontconfig defaults
│   │   └── environment.nix            # X11 keymap (EU layout), env vars (EDITOR, cursor theme, Quickshell)
│   │
│   ├── programs/
│   │   ├── default.nix                # Aggregator
│   │   ├── common.nix                 # Firefox, Thunar, Yazi, nix-ld
│   │   ├── gaming.nix                 # Steam + Proton-GE, Gamemode, Gamescope, AAGL launchers, Minecraft overlay
│   │   └── flatpak.nix               # Flatpak + Flathub repo + XIV Launcher
│   │
│   ├── services/
│   │   ├── default.nix                # Aggregator
│   │   ├── audio.nix                  # PipeWire (ALSA, PulseAudio compat, 32-bit support)
│   │   ├── printing.nix              # CUPS printing service
│   │   ├── minecraft-server.nix       # Fabric Minecraft server (8 GB RAM, auto-start disabled)
│   │   └── system.nix                 # systemd timeout tweaks, getty autologin, Blueman
│   │
│   ├── users/
│   │   ├── default.nix                # Aggregator
│   │   └── tom.nix                    # User "tom": groups, 70+ packages (dev tools, media, gaming, …)
│   │
│   └── shell/
│       ├── default.nix                # Aggregator
│       ├── aliases.nix                # Shell aliases (ns, nb, nu, sys)
│       ├── scripts.nix                # writeShellScriptBin wrappers for scripts/ + yazi override
│       ├── bash.nix                   # ble.sh, zoxide, atuin, yazi shell function
│       └── symlinks.nix              # Custom 'links' option for activation-time symlinks (hypr configs)
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
└── hypr/                              # Hyprland config (symlinked to ~/.config/hypr/ at activation time)
    ├── hyprland.conf                  # Main config — monitors, keybinds, window rules, animations
    └── xdph.conf                      # xdg-desktop-portal-hyprland config (screencopy tokens)
```

---

## 🔗 Flake Inputs

| Input | Source | Purpose |
|---|---|---|
| **nixpkgs** | `nixos/nixpkgs` (unstable) | Base package set & NixOS modules |
| **quickshell** | `outfoxxed/quickshell` | Quickshell widget framework |
| **aagl** | `ezKEa/aagl-gtk-on-nix` | Anime game launchers (e.g. An Anime Game Launcher) |
| **prismlauncher** | `PrismLauncher/PrismLauncher` | Minecraft launcher (Prism) |
| **nix-minecraft** | `Infinidoge/nix-minecraft` | Declarative Minecraft server management |
| **putah** | `QuetzColito/putah` | Putah utility |

All external inputs follow the flake's `nixpkgs` to avoid version mismatches.

---

## ⚡ Quick Reference — Shell Aliases

These aliases are defined in `modules/shell/aliases.nix` and available in every shell:

| Alias | Expands to | Description |
|---|---|---|
| `ns` | `nh os switch` | Rebuild the system and **switch** immediately |
| `nb` | `nh os boot` | Rebuild the system for the **next boot** |
| `nu` | `nix flake update --flake /home/tom/SystemConfig/ --commit-lock-file` | **Update** all flake inputs and commit the new lock file |
| `sys` | `codium ~/SystemConfig` | Open this config in **VSCodium** |

---

## 🔨 Rebuilding

```bash
# After making changes, rebuild and switch live:
ns

# Or stage the rebuild for the next boot:
nb

# Update all flake inputs first, then rebuild:
nu && ns
```

Under the hood, [`nh`](https://github.com/viperML/nh) wraps `nixos-rebuild` with nicer output and automatic garbage collection.

---

## 🧩 How It Works

### The Import Chain

```
flake.nix
  ├─► hardware-configuration.nix    (auto-generated, imported directly by flake)
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

Each `default.nix` is a simple **aggregator** that imports the sibling files in its directory, so `configuration.nix` only needs seven import paths.

### Custom Options

| Option | Defined in | Default | Usage |
|---|---|---|---|
| `mainUser` | `modules/core/variables.nix` | `"tom"` | Referenced throughout modules via `config.mainUser` |
| `links` | `modules/shell/symlinks.nix` | — | Declarative activation-time symlinks (used for Hyprland config) |

---

## 🚀 How to Extend

### Add a new system package

Open **`modules/users/tom.nix`** and append the package to the user's `users.users.tom.packages` list. If the package should be available to *all* users, add it to `environment.systemPackages` in the most relevant module (or create a new one).

### Add a new program or service module

1. **Create** a new `.nix` file in the appropriate category folder:
   ```
   modules/programs/my-app.nix      # for applications
   modules/services/my-daemon.nix   # for services / daemons
   modules/hardware/my-device.nix   # for hardware support
   ```
2. **Write** your NixOS options inside the file:
   ```nix
   { pkgs, ... }:
   {
     environment.systemPackages = [ pkgs.my-app ];
     # or services.my-daemon.enable = true;
   }
   ```
3. **Register** it by adding the file to the category's `default.nix`:
   ```nix
   { ... }:
   {
     imports = [
       ./existing-module.nix
       ./my-app.nix          # ← add this line
     ];
   }
   ```
4. **Rebuild**: `ns`

### Add a new shell script

1. **Write** the script in the `scripts/` directory (e.g. `scripts/my-script.sh`).
2. **Wrap** it in `modules/shell/scripts.nix` using `writeShellScriptBin`:
   ```nix
   (pkgs.writeShellScriptBin "my-script" (builtins.readFile ../../scripts/my-script.sh))
   ```
3. **Rebuild**: `ns` — the script is now on `$PATH`.

### Add a new shell alias

Edit **`modules/shell/aliases.nix`** and add a key-value pair to `environment.shellAliases`.

### Add a new module category

1. Create a new directory under `modules/` (e.g. `modules/virtualization/`).
2. Add a `default.nix` aggregator inside it.
3. Import the new category in `configuration.nix`:
   ```nix
   imports = [
     # …existing imports
     ./modules/virtualization
   ];
   ```

### Symlink additional dotfiles

Use the custom `links` option defined in `modules/shell/symlinks.nix` to declaratively create symlinks at system activation time — the same mechanism used to place the `hypr/` directory into `~/.config/hypr/`.

---

## 🖥️ Desktop — Hyprland

The system runs the **Hyprland** Wayland compositor with **UWSM** as the login shell launcher. Three monitors are configured:

| Output | Position | Role |
|---|---|---|
| `DP-1` | `0×0` | Primary (workspaces 1–6) |
| `DP-2` | `-2560×0` | Left |
| `HDMI-A-1` | `3440×300` | Right |

The Hyprland configuration lives in the `hypr/` directory and is symlinked to `~/.config/hypr/` at activation time.

---

## 🎮 Gaming

- **Steam** with Proton-GE via `programs.steam`
- **Gamemode** & **Gamescope** for performance optimisation
- **AAGL** (An Anime Game Launcher) for anime-related game launchers
- **PrismLauncher** for Minecraft (client)
- **Flatpak** with the XIV Launcher for Final Fantasy XIV
- Helper scripts: `guildwars2`, `warframe`, `protonhax`

---

## 🎵 Audio

PipeWire is the audio stack, configured in `modules/services/audio.nix` with:
- ALSA support
- PulseAudio compatibility layer
- 32-bit application support (for games)

---

## 🇯🇵 Input Methods

**fcitx5** with the **mozc** engine is configured in `modules/core/locale.nix` for Japanese input alongside the default `en_US.UTF-8` / `de_DE.UTF-8` locale setup.

---

## 📜 License

This is a personal system configuration shared for reference. Feel free to take inspiration or borrow snippets for your own NixOS setup.
