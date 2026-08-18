# 🎮 BallXPit - Endless Mode AFK & Fusion Automation

An automated helper script written in **AutoHotkey v2** designed specifically for **BALL x PIT** (`Balls.exe`). 

This script automates endless runs by detecting screen states via pixel color checks, automatically dismissing mid/late-game **Fusion** popups, navigating level-ups, and optionally moving your character left and right during normal gameplay to keep runs completely AFK-friendly.

---

## 📋 Features

- **Non-Blocking Automation:** Built using an event-driven queue system (no long `Sleep` delays) ensuring hotkeys respond instantly and execution can cancel gracefully.
- **Dynamic State Detection:** Monitors specific pixels using precise RGB color matching to detect whether the game is currently in a **Fusion**, **Level-Up**, or **Normal Gameplay** state.
- **Fusion Auto-Dismiss:** Automatically clicks the claim/accept prompts and issues `Esc` key sequences to clear multi-stage fusion screens.
- **Optional Character Movement:** Simulates continuous left and right movement (`A` and `D` keys) during normal gameplay.
- **Safe Mouse Restoration:** Remembers your cursor position before performing automatic clicks and restores it afterward so it doesn't disrupt manual input.
- **Built-in Debug Mode:** Toggle visual overlay ToolTips on screen to see what state the script is detecting in real-time.

---

## ⚙️ Prerequisites

1. **AutoHotkey v2.0+** installed on your system. ([Download AutoHotkey v2](https://www.autohotkey.com/))
2. **BALL x PIT** running in Windowed or Borderless Windowed mode.

---

## ⚠️ Display Resolution & Calibration Notice

> **IMPORTANT:**
> The screen coordinates (`ColorCheckX/Y`, `ClicksFusion`, `ClicksLevel`) defined in this script are calibrated based on specific window client coordinates. **If your game resolution, aspect ratio, or window scale differs, you MUST tweak these variables to match your display.**

### Key Variables to Adjust for Your Resolution:

| Variable Group | Purpose |
| :--- | :--- |
| **State Detection Points** | Coordinates used to sample pixel colors to detect screens: |
| `ColorCheckXFusion` / `ColorCheckYFusion` | Pixel coordinate checked for Fusion popups. |
| `ColorCheckXLevel` / `ColorCheckYLevel` | Pixel coordinate checked for Level-Up popups ("X" icon). |
| `ColorCheckXNormal` / `ColorCheckYNormal` | Pixel coordinate checked for normal state (e.g., UI Pickaxe). |
| **Click Sequences** | Array of `{X: ..., Y: ...}` screen locations clicked automatically: |
| `ClicksFusion` | Coordinates clicked to confirm/accept Fusion screens. |
| `ClicksLevel` | Coordinates clicked to select items/level upgrades. |
| **Color Tolerance** | |
| `ColorVariation` | Default is `15`. Increase this if lighting changes cause false negatives. |

*You can use the **Window Spy** tool (included with AutoHotkey) while focused on the game window (using **Client** relative coordinates) to find your exact pixel positions.*

---

## 🎮 How to Use

### Hotkey Controls

| Hotkey | Action | Description |
| :---: | :--- | :--- |
| **`F4`** | **Start** | Begins the automation loop. |
| **`F5`** | **Stop** | Halts automation immediately and safety-releases any held keys (`A`/`D`/`Esc`). |
| **`F6`** | **Toggle Debug** | Displays real-time on-screen ToolTips showing detected game states. |

---

## 🔧 Script Configuration Options

At the top of the `.ahk` file, you can modify these boolean flags to change default behavior:

```autohotkey
IsRunning     := false ; Set to true if you want the script to auto-start when launched
ShowDebug     := false ; Set to true to enable debug ToolTips by default
MoveCharacter := true  ; Set to false if you want to disable A/D character movement during normal play
```

### Customizing Key Duration & Actions
You can customize the key presses and hold durations for each state inside the script settings:

* **`KeysFusion`**: Adjust key press duration/keys for dismissing Fusion screens (Default: `Esc` held for `10ms`).
* **`KeysNormal`**: Adjust movement patterns for idle gameplay (Default: Alternates holding `A` and `D` for `1400ms` each).

---

## 🛠️ State Detection Breakdown

The script operates on 3 primary states determined by pixel color checks:

1. **`Fusion` State:** Triggered when the Fusion screen appears. Triggers `ClicksFusion` coordinates 3 times, followed by `KeysFusion` key presses.
2. **`Level` State:** Triggered on level-up options. Executes clicks in `ClicksLevel` to select upgrades automatically.
3. **`Normal` State:** Triggered when neither pop-up is detected. Runs `KeysNormal` sequences to oscillate character position if `MoveCharacter` is set to `true`.

---

## 📜 License & Disclaimer

This script is provided as-is for personal Quality-of-Life automation during endless runs. Ensure you tune the target colors and pixel coordinates to match your monitor and display settings prior to running.
