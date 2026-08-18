# 🎮 Gaming AutoHotkey (AHK) Scripts & Utilities

A curated, well-structured collection of AutoHotkey (v2) scripts, macros, and utility tools designed to enhance gaming experience, automate repetitive actions, and optimize hotkey management across various PC games.

---

## 📋 Table of Contents
- [Features](#-features)
- [Repository Structure](#-repository-structure)
- [Prerequisites](#-prerequisites)
- [Installation & Setup](#-installation--setup)
- [Featured Scripts](#-featured-scripts)
- [Configuration & Usage](#-configuration--usage)
- [Safety & Anti-Cheat Notice](#-safety--anti-cheat-notice)
- [Contributing](#-contributing)
- [License](#-license)

---

## ✨ Features

- **🎮 Game-Specific Profiles:** Custom scripts tailored for specific titles (RPGs, FPS, RTS, MMOs).
- **⚙️ Dynamic Configuration:** Easily toggle features, adjust keybinds, and configure delays via localized INI/JSON settings.
- **⚡ Hotkey Manager & GUI:** Lightweight overlay/GUI launchers to toggle macros seamlessly mid-game.
- **🔒 Anti-Cheat Conscious Design:** Focus on QoL (Quality of Life) enhancements, accessibility features, and single-action hotkeys rather than intrusive memory editing.
- **🛠️ Helper Utilities:** Included support files, icon packs, audio feedback cues, and dependency libraries.

---

## 📁 Repository Structure

```text
.
├── docs/                   # Additional documentation and guide images
├── lib/                    # Shared AutoHotkey libraries and subroutines
│   ├── Gdip_All.ahk        # GDI+ image processing library
│   └── SoundEffects.ahk    # Audio feedback helper script
├── scripts/                # Game-specific scripts
│   ├── PathOfExile/        # Trade/Macro helper scripts for PoE
│   │   ├── PoE_Flasks.ahk
│   │   └── config.ini
│   ├── FinalFantasyXIV/    # Crafter/Fisher macros and keybind helpers
│   │   └── FFXIV_Crafter.ahk
│   └── Generic/            # Universal gaming tools
│       ├── AutoClicker.ahk
│       ├── CrosshairOverlay.ahk
│       └── WindowedBorderless.ahk
├── assets/                 # Custom icons, sound cues, and UI templates
├── config.template.ini    # Master template for custom configuration
├── LICENSE                 # MIT License
└── README.md               # Repository documentation
```

---

## 📌 Prerequisites

1. **AutoHotkey v2:** Download and install the latest release from the [Official AutoHotkey Website](https://www.autohotkey.com/).
   * *Note: Most scripts in this repository are written for **AHK v2**. If you are using AHK v1.1, check the specific script header for legacy compatibility notes.*
2. **Administrator Privileges:** Some online games require running AHK scripts as Administrator to intercept input keys properly.

---

## 🚀 Installation & Setup

1. **Clone or Download the Repository:**
   ```bash
   git clone https://github.com/your-username/gaming-ahk-scripts.git
   ```
   *Or download the [ZIP archive](../../archive/main.zip) and extract it to your preferred folder.*

2. **Configure Settings:**
   * Copy `config.template.ini` to `config.ini` inside the respective script folder.
   * Edit keybinds, toggle options, or adjust delay timers in `config.ini` using any text editor (e.g., VS Code or Notepad++).

3. **Run a Script:**
   * Double-click any `.ahk` file located in the `scripts/` directory to run it directly.
   * Right-click the system tray icon to access script settings, suspend hotkeys, or exit.

---

## 🛠️ Featured Scripts

| Script Name | Category | Description |
| :--- | :--- | :--- |
| **`ballxpit_clicker_v5.ahk`** | Generic | Toggleable auto-clicker for endless mode. |

---
### 🛠️ Example Script Types

| **`WindowedBorderless.ahk`** | Utility | Forces any windowed game into a seamless Borderless Fullscreen mode (`Win + F11`). |
| **`CrosshairOverlay.ahk`** | Overlay | Draws a customizable hardware/software crosshair overlay for games without native reticles. |
| **`PoE_Flasks.ahk`** | RPG / QoL | Utility macro layout and quick-exit tools for Path of Exile. |
| **`FFXIV_Crafter.ahk`** | MMO | One-button crafting macro automation with sound notifications on completion. |

---

## ⚙️ Configuration & Usage

### Standard Hotkey Controls
While individual scripts may define custom bindings, the following universal controls apply across most scripts in this repository:


* `F4` – **Start the automations**
* `F5` – **Suspend/Resume** pause automations. 
* `F6` – **Toggle Debug** Enable/Disable debug on the currently running script.

### Example Configuration (`config.ini`)
```ini
[General]
ToggleKey=F8
ClickIntervalMs=50
RandomizeInterval=true

[Overlay]
CrosshairColor=0xFF0000
CrosshairSize=12
Opacity=200
```

---

## ⚠️ Safety & Anti-Cheat Notice

> **IMPORTANT DISCLAIMER**
> 
> * **Use at Your Own Risk:** Certain online multiplayer games (e.g., titles protected by Easy Anti-Cheat, BattlEye, Vanguard, or Ricochet) have strict policies regarding background automation software.
> * **Terms of Service:** Automating multiple actions per single keystroke ("1 key = multiple server actions") may violate the Terms of Service (ToS) of competitive online games.
> * **Best Practice:** Keep automation scripts limited to single-player games, offline titles, or strictly QoL hotkeys in permitted games. The maintainers of this repository are not responsible for any account bans or restrictions.

---

## 🤝 Contributing

Contributions are welcome! If you'd like to add a new script, fix a bug, or improve documentation:

1. Fork the project repository.
2. Create your feature branch (`git checkout -b feature/NewGameScript`).
3. Commit your changes with clear messages (`git commit -m "Add custom macro for Game X"`).
4. Push to the branch (`git push origin feature/NewGameScript`).
5. Open a Pull Request.

Please ensure all new scripts include standard error handling, clear header documentation, and stick to **AutoHotkey v2** syntax where possible.

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for more information.# gaming_ahk_scripts
Gaming Related AutoHotKey Scripts
