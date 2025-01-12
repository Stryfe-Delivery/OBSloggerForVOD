obs = obslua

log_file_path = "C:/path_to_your_log_file/scene_key_log.txt"  -- Set the file path to where you want the log to be saved

-- Function to initialize the script
function script_description()
    return "Logs scene changes with timestamps and Escape key presses."
end

-- Function to handle logging of scene changes
function log_scene_change(transition)
    local time = os.date("%Y-%m-%d %H:%M:%S")
    local scene = obs.obs_frontend_get_current_scene()
    local scene_name = obs.obs_source_get_name(scene)
    
    local file = io.open(log_file_path, "a")
    file:write(time .. " - Scene changed to: " .. scene_name .. "\n")
    file:close()
end

-- Function to load the script
function script_load(settings)
    obs.obs_frontend_add_event_callback(log_scene_change)
end

-- Function to run continuously for checking key events
function script_update(settings)
end

-- Optional: Clean up when the script is unloaded
function script_unload()
end
