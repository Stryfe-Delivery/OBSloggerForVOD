Esc::
    ; Get the current timestamp
    FormatTime, timestamp,, yyyy-MM-dd HH:mm:ss
    ; Append to the log file whenever the Escape key is pressed
    FileAppend, %timestamp% - Escape key pressed`n, C:\path_to_your_log_file\scene_key_log.txt
    return
