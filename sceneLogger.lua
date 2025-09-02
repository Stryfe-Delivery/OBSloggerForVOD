obs = obslua

-- Configuration
log_file_path = "D:/obslogs/scene_key_log.txt"  -- Update this path
-- note this path may need to be manually generated to allow write

-- Internal state
stream_start_time = nil
record_start_time = nil
hotkey_id = obs.OBS_INVALID_HOTKEY_ID

-- Function to write to the log file
function write_to_log(message)
    local file = io.open(log_file_path, "a")
    if file then
        file:write(message .. "\n")
        file:close()
    end
end

-- Function to format time difference
function format_time_diff(seconds)
    if not seconds then return "N/A" end
    
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

-- Function to get relative time since streaming/recording started
function get_relative_time()
    local current_time = os.time()
    
    if stream_start_time then
        return current_time - stream_start_time
    elseif record_start_time then
        return current_time - record_start_time
    end
    
    return nil
end

-- Function to log scene changes
function on_event(event)
    local time = os.date("%Y-%m-%d %H:%M:%S")
    local relative_time = get_relative_time()
    
    if event == obs.OBS_FRONTEND_EVENT_SCENE_CHANGED then
        local scene = obs.obs_frontend_get_current_scene()
        local scene_name = obs.obs_source_get_name(scene)
        obs.obs_source_release(scene)
        
        write_to_log(string.format("%s (Relative: %s) - Scene changed to: %s", 
                                  time, format_time_diff(relative_time), scene_name))
    
    elseif event == obs.OBS_FRONTEND_EVENT_STREAMING_STARTED then
        stream_start_time = os.time()
        write_to_log(string.format("%s - Streaming started", time))
        
    elseif event == obs.OBS_FRONTEND_EVENT_STREAMING_STOPPED then
        write_to_log(string.format("%s (Relative: %s) - Streaming stopped", 
                                  time, format_time_diff(get_relative_time())))
        stream_start_time = nil
        
    elseif event == obs.OBS_FRONTEND_EVENT_RECORDING_STARTED then
        record_start_time = os.time()
        write_to_log(string.format("%s - Recording started", time))
        
    elseif event == obs.OBS_FRONTEND_EVENT_RECORDING_STOPPED then
        write_to_log(string.format("%s (Relative: %s) - Recording stopped", 
                                  time, format_time_diff(get_relative_time())))
        record_start_time = nil
    end
end

-- Function to log Escape key press
function on_escape_pressed(pressed)
    if pressed then
        local time = os.date("%Y-%m-%d %H:%M:%S")
        local relative_time = get_relative_time()
        
        write_to_log(string.format("%s (Relative: %s) - Escape key pressed", 
                                  time, format_time_diff(relative_time)))
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
    -- Register event callbacks
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
    return "Logs scene changes and Escape key presses with timestamps relative to streaming/recording start."
end

-- No continuous update needed
function script_update(settings)
end

-- Cleanup on script unload
function script_unload()
end
