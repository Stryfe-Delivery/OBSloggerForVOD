obs = obslua

log_file_path = "D:/obslogs/scene_key_log.txt"  -- Update this path
-- if this path is missing the file may not be generated

-- Hotkey ID and data structure
hotkey_id = obs.OBS_INVALID_HOTKEY_ID
escape_pressed_callback = nil

-- Function to write to the log file
function write_to_log(message)
    local file = io.open(log_file_path, "a")
    if file then
        file:write(message .. "\n")
        file:close()
    end
end

-- Function to log scene changes
function on_event(event)
    if event == obs.OBS_FRONTEND_EVENT_SCENE_CHANGED then
        local time = os.date("%Y-%m-%d %H:%M:%S")
        local scene = obs.obs_frontend_get_current_scene()
        local scene_name = obs.obs_source_get_name(scene)
        obs.obs_source_release(scene)
        write_to_log(time .. " - Scene changed to: " .. scene_name)
    end
end

-- Function to log Escape key press
function on_escape_pressed(pressed)
    if pressed then
        local time = os.date("%Y-%m-%d %H:%M:%S")
        write_to_log(time .. " - Escape key pressed")
    end
end

-- Save hotkey configuration
function script_save(settings)
    local hotkey_save_array = obs.obs_hotkey_save(hotkey_id)
    obs.obs_data_set_array(settings, "escape_hotkey", hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
end

-- Load hotkey configuration
function script_load(settings)
    -- Register scene change callback
    obs.obs_frontend_add_event_callback(on_event)
    
    -- Register Escape key hotkey
    hotkey_id = obs.obs_hotkey_register_frontend(
        "escape_key_logger",
        "Log Escape Key Press",
        on_escape_pressed
    )
    
    -- Load hotkey configuration from settings
    local hotkey_save_array = obs.obs_data_get_array(settings, "escape_hotkey")
    obs.obs_hotkey_load(hotkey_id, hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
end

-- Set hotkey defaults (optional)
function script_defaults(settings)
    -- You can set default hotkey combination here if needed
end

-- Description shown in OBS
function script_description()
    return "Logs scene changes and Escape key presses to a text file. " ..
           "Assign a hotkey in OBS Settings to capture the Escape key."
end

-- No continuous update needed
function script_update(settings)
end

-- Cleanup on script unload
function script_unload()
end
