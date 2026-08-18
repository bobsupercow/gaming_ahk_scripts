#Requires AutoHotkey v2.0

; --- Configuration ---
IsRunning := false
ShowDebug := false ; Set to true to start with debugging ON, false for OFF
MoveCharacter := true ;Set to true to move the character left and right during normal play. 

; Target window details from Window Spy
TargetWin := "BALL x PIT ahk_class UnityWndClass ahk_exe Balls.exe"

;Set KeyDelay for Keyboard Input
SetKeyDelay(50, 50)     ; Delays between keys, and hold duration for SendEvent


; --- Configuration ---
;!!!!These coordinates are entirely dependent on your resolution, and these are what work for me. I'm sure with more work, they could be determined dynamically based on ratios, but I'm too lazy. 
; Window-relative Client coordinates and target colors
ColorCheckXFusion := 300
ColorCheckYFusion := 5
TargetColorFusion := 0x000000

;The "X" in upper left corner
ColorCheckXLevel := 58
ColorCheckYLevel := 58
TargetColorLevel := 0xD5A19D

;The "Pickaxe" in the health bar - This location may be character dependent.
ColorCheckXNormal := 36
ColorCheckYNormal := 48
TargetColorNormal := 0xAD6E18

; Color range tolerance (0 = exact, 255 = match anything)
ColorVariation := 15 

; Click coordinates (relative to the window Client area)
;Fusion, Click initial $$$ button 3 times to ensure quick response. (Esc key is used for remaining 2 screens)
ClicksFusion := [
    {X: 900, Y: 700},
    {X: 900, Y: 700},
    {X: 900, Y: 700}
]
ClicksLevel := [
    {X: 190, Y: 910}, 
    {X: 450, Y: 1200} 
]

;=========================================================
; --- NEW: Keystroke Configurations ---
; Define any key string and how many milliseconds to hold it down
KeysFusion := [
    {Key: "Esc", Duration: 10},
    {Key: "Esc", Duration: 10}
    ;{Key: "a", Duration: 500}   ; Then hold A for 0.5 seconds
]

KeysLevel := [
    ;{Key: "s", Duration: 800},  ; Hold S for 0.8 seconds
    ;{Key: "d", Duration: 1200}  ; Then hold D for 1.2 seconds
]

KeysNormal := [
    {Key: "a", Duration: 1400},  ; Hold A for 2 seconds
    {Key: "d", Duration: 1400}   ; Hold D for 2 secondsd
]

; --- State variable set by GetState() ---
currentState := "Unknown"

; --- NEW: Action engine state (non-blocking) ---
actionState := "Idle"
actionCancelToken := 0

; Tracks the currently-held key (so we can safely release it)
heldKey := ""          ; last key we sent down
heldKeyDown := false   ; whether it's currently down

; Stores the current scripted action step index + end time
actionSteps := []      ; array of step objects
stepIndex := 1
stepUntil := 0

; --- Hotkeys ---

; F4 starts the automation
F4:: {
    global IsRunning
    if (IsRunning)
        return
        
    IsRunning := true
    SetTimer(ClickLocations, 50)
    DebugTip("Automation Started", 1500)
}

; F5 stops the automation
F5:: {
    global IsRunning
    IsRunning := false
    SetTimer(ClickLocations, 0)
    ToolTip() ; Clears active debug tooltip instantly
    DebugTip("Automation Stopped", 1500)

    ; --- NEW: ensure no keys remain held after stopping ---
    ReleaseHeldKey()
}

; F6 toggles the debugging mode on and off
F6:: {
    global ShowDebug
    ShowDebug := !ShowDebug ; Switches true to false, or false to true
    
    if (!ShowDebug) {
        ToolTip() ; Immediately remove the tooltip if turning off
        DebugTip("Debugging Disabled", 1500)
    } else {
        DebugTip("Debugging Enabled", 1500)
    }
}

;=========================================================


; --- Core Logic ---
ClickLocations() {
    global ShowDebug, MoveCharacter, currentState, TargetWin

    ; Enforce coordinate system matching Window Spy's "Client" metrics
    CoordMode("Pixel", "Client")
    CoordMode("Mouse", "Client")
    CoordMode("ToolTip", "Screen")

    ; DEBUG CHECK 1: Ensure game window is present
    if !WinExist(TargetWin) {
        if (ShowDebug)
            ToolTip("⚠️ DEBUG: Game Window NOT Found!`nLooking for: " TargetWin)
        return
    }

    GetState()  ; sets currentState

    ; --- NEW: run/advance action without blocking timer ---
    ; We only start a new action if the requested state changed.
    StartOrUpdateAction()

    ; Advance the action one “slice” if it’s waiting on time.
    AdvanceAction()
}

; --- NEW: Non-blocking action selection ---
StartOrUpdateAction() {
    global currentState, actionState, actionCancelToken, actionSteps, stepIndex, stepUntil, heldKey, heldKeyDown

    ; If we're already in the same state action, don't rebuild steps.
    ; (We still advance via AdvanceAction().)
    if (
        (currentState = "Fusion"  && actionState = "Fusion") ||
        (currentState = "Level"   && actionState = "Level")  ||
        (currentState = "Normal"  && actionState = "Normal")
    ) {
        return
    }

    ; --- NEW: state changed while running; cancel current scripted action ---
    actionCancelToken++
    CancelCurrentAction()

    ; --- NEW: build the steps for the newly detected state ---
    if (currentState = "Fusion") {
        if (ShowDebug)
            ToolTip("⚡ FUSION FOUND!")

        ; Keep original cursor position (captured per-action start)
        ; --- NEW: We'll store it as a step-local variable via closure-less globals ---
        MouseGetPos(&origX, &origY, &origWin)

        actionState := "Fusion"
        actionSteps := BuildFusionSteps(origX, origY)
        stepIndex := 1
        stepUntil := 0

    } else if (currentState = "Level") {
        if (ShowDebug)
            ToolTip("⚡ LEVEL FOUND!")

        MouseGetPos(&origX, &origY, &origWin)

        actionState := "Level"
        actionSteps := BuildLevelSteps(origX, origY)
        stepIndex := 1
        stepUntil := 0

    } else if (currentState = "Normal") {
        if (ShowDebug)
            ToolTip("⚡ MATCH FOUND: Executing Normal Actions!")
        if (MoveCharacter) {
            actionState := "Normal"
            actionSteps := BuildNormalSteps()
            stepIndex := 1
            stepUntil := 0
        } else {
            actionState := "Idle"
            actionSteps := []
        }

    } else {
        actionState := "Idle"
        actionSteps := []
    }
}

; --- NEW: Build steps for each state ---
BuildFusionSteps(origX, origY) {
    global ClicksFusion, KeysFusion
    steps := []

    ; Click sequence
    for point in ClicksFusion {
        steps.Push({type: "click", x: point.X, y: point.Y})
        steps.Push({type: "sleep", ms: 50})
    }

    ; Keystroke holds (non-blocking via stepUntil)
    for item in KeysFusion {
        steps.Push({type: "keyDown", key: item.Key})
        steps.Push({type: "sleep", ms: item.Duration})
        steps.Push({type: "keyUp", key: item.Key})
        steps.Push({type: "sleep", ms: 50})
    }

    ; Restore mouse
    steps.Push({type: "mouseMove", x: origX, y: origY, ms: 0})

    return steps
}

BuildLevelSteps(origX, origY) {
    global ClicksLevel, KeysLevel
    steps := []

    ; Click sequence
    for point in ClicksLevel {
        steps.Push({type: "click", x: point.X, y: point.Y})
        steps.Push({type: "sleep", ms: 50})
    }

    ; Keystroke holds (non-blocking via stepUntil)
    for item in KeysLevel {
        steps.Push({type: "keyDown", key: item.Key})
        steps.Push({type: "sleep", ms: item.Duration})
        steps.Push({type: "keyUp", key: item.Key})
        steps.Push({type: "sleep", ms: 50})
    }

    ; Restore mouse
    steps.Push({type: "mouseMove", x: origX, y: origY, ms: 0})

    return steps
}

BuildNormalSteps() {
    global KeysNormal
    steps := []

    ; Keystroke holds (non-blocking via stepUntil)
    for item in KeysNormal {
        steps.Push({type: "keyDown", key: item.Key})
        steps.Push({type: "sleep", ms: item.Duration})
        steps.Push({type: "keyUp", key: item.Key})
        steps.Push({type: "sleep", ms: 50})
    }

    return steps
}

; --- NEW: Advance one step per timer tick; no long blocking sleeps ---
AdvanceAction() {
    global actionCancelToken, actionSteps, stepIndex, stepUntil, actionState, heldKey, heldKeyDown, ShowDebug

    if (actionState = "Idle" || actionSteps.Length = 0)
        return

    ; If we're currently waiting for time to elapse, just check the timer.
    if (stepUntil && A_TickCount < stepUntil)
        return

    ; If time expired, clear wait.
    stepUntil := 0

    ; If finished all steps, return to Idle
    if (stepIndex > actionSteps.Length) {
        actionState := "Idle"
        actionSteps := []
        ReleaseHeldKey() ; safety
        return
    }

    ; Execute the current step. These operations must be short.
    step := actionSteps[stepIndex]
    stepIndex++

    if (step.type = "click") {
        Click(step.x, step.y)

    } else if (step.type = "mouseMove") {
        MouseMove(step.x, step.y, step.ms)

    } else if (step.type = "keyDown") {
        Send("{"
            . step.key . " down}")
        heldKey := step.key
        heldKeyDown := true

    } else if (step.type = "keyUp") {
        ; Only release if it matches the held key.
        if (heldKeyDown && heldKey = step.key) {
            Send("{"
                . step.key . " up}")
            heldKeyDown := false
            heldKey := ""
        } else {
            ; --- NEW: If keyUp arrives after cancellation or mismatch, still ensure it is up ---
            Send("{"
                . step.key . " up}")
        }

    } else if (step.type = "sleep") {
        ; --- NEW: non-blocking wait ---
        stepUntil := A_TickCount + step.ms
        return  ; stop processing further steps this tick
    }
}

; --- NEW: Cancel any running scripted action quickly ---
CancelCurrentAction() {
    global actionState, actionSteps, stepIndex, stepUntil, heldKey, heldKeyDown

    ; release any key we might have held
    ReleaseHeldKey()

    actionState := "Idle"
    actionSteps := []
    stepIndex := 1
    stepUntil := 0
}

; --- NEW: release held key helper ---
ReleaseHeldKey() {
    global heldKey, heldKeyDown
    if (heldKeyDown && heldKey != "") {
        Send("{" . heldKey . " up}")
    }
    heldKeyDown := false
    heldKey := ""
}

; --- Gets the current game state (*Level-Up, Fusion, or Normal) by color matching pixels ---
; --- No longer uses PixelSearch per tick, instead just color compare using PixelGetColor and ColorClose Function ---
; --- This section of code is most volatile in event of an update. It also may not work with Color Modifications (e.g. color blind mode) ---
GetState() {
    global currentState
    global ShowDebug

    ; If Fusion didn't match, classify via direct color sampling
    local actualFusion := PixelGetColor(ColorCheckXFusion, ColorCheckYFusion)
    local actualLevel := PixelGetColor(ColorCheckXLevel, ColorCheckYLevel)
    local actualNormal := PixelGetColor(ColorCheckXNormal, ColorCheckYNormal)

    if ColorClose(actualFusion, TargetColorFusion, ColorVariation) {
        currentState := "Fusion"
        return
    }

    if ColorClose(actualLevel, TargetColorLevel, ColorVariation) {
        currentState := "Level"
        return
    }

    currentState := "Normal"
}

ColorClose(actualColor, targetColor, tol) {
    ; Compare per channel (R,G,B) in RGB order.
    ; Both colors expected as 0xRRGGBB.
    local ar := (actualColor >> 16) & 0xFF
    local ag := (actualColor >> 8)  & 0xFF
    local ab := (actualColor)       & 0xFF

    local tr := (targetColor >> 16) & 0xFF
    local tg := (targetColor >> 8)  & 0xFF
    local tb := (targetColor)       & 0xFF

    return (Abs(ar - tr) <= tol) && (Abs(ag - tg) <= tol) && (Abs(ab - tb) <= tol)
}

; Helper FUNCTIONS
;=========================================================

; Helper function for notifications
DebugTip(text, duration) {
    CoordMode("ToolTip", "Screen")
    ToolTip(text)
    SetTimer(() => ToolTip(), -duration)
}
