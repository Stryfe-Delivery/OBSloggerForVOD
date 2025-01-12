# OBSloggerForVOD
log timestamps of scenes to cut to ease VOD editing

OBS automatically generates log files for each session. These log files include detailed information about the session, including scene transitions.
To find these log files:
    Open OBS.
    Go to Help > Log Files > View Log Files.
    You can also find them manually on your computer at C:\Users\[YourName]\AppData\Roaming\obs-studio\logs (Windows) or ~/Library/Application Support/obs-studio/logs/ (Mac).
However this may not be easily accessed and added to using other tools, it may also have extra clutter. The Lua script will log the scene transitions with timestamps. It will run in the background and be able to append the scene name and time of transition to a log file.
    Open OBS.
    Go to Tools > Scripts.
    Click + to add a new Lua script and select the script you just created.
Since Lua in OBS cannot directly capture keyboard events, you need an external tool (like AutoHotkey) to listen for the Escape key and log it to the same file.
    Install AutoHotkey from here.
    Create a new AutoHotkey script with the ahk file
Notes:
  The AutoHotkey script only works on Windows.
  You will need to run both scripts (OBS Lua script and AutoHotkey) simultaneously during your stream to capture both scene transitions and key presses.
  The log file will be appended with each event, so you can review it later to track what happened during the stream.
