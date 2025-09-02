# OBSloggerForVOD
log timestamps of scenes to cut to ease VOD editing. when streaming and saving vods for youtube it's helpful to be able to cut out ads, raids, etc. which are often associated with scene changes. Changing the scene creates a timestamped event and you can easily trim down just to the main scenes you want. 

to install: <br>
    save file to C:\ProgramFiles\obs-studio\data\obs-plugins\frontend-tools\scripts (or appropriate path) <br>
to run:<br>
    Open OBS <br>
    Go to Tools > Scripts <br>
    Click + to add a new Lua script and select the file from this repo<br>
to view:<br>
    open directory hard coded in file (change as needed)

Since Lua in OBS cannot directly capture keyboard events, you need an external tool (like AutoHotkey) to listen for the Escape key and log it to the same file. <br>
    Install AutoHotkey from here. <br>
    Create a new AutoHotkey script with the ahk file <br>

    
Notes:<br>
  The AutoHotkey script only works on Windows, but scene logger should work on Mac/Linux <br>
  You will need to run both scripts (OBS Lua script and AutoHotkey) simultaneously during your stream to capture both scene transitions and key presses. <br>
  if AHK doesnt run, the LUA will still run fine it just wont capture those keypress events <br>
  The log file will be appended with each event, so you can review it later to track what happened during the stream.<br>
  For video editing, it is best to start with the last event and trim towards the start of the video to keep things in sync
