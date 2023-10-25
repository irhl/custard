--[[  License: The MIT License (MIT)
      Source: https://github.com/irhl/custard

      Fonts:
      CozetteVector, Scientifica

      PLEASE PAY ATTENTION
      before installing this script, there are
      a list of current issues you need to know.

      #2 23-10-2023
      video playback delay
      when switching workspaces

      this isn't meant for normal use, it is
      intended for ricing and making art,
      so don't expect full functionality
      unless you pay me some pull requests
--]]

function file_extension(path)
    return string.match("mp4|mkv|webm",
    path:match("%.([^%.]+)$")) and true or false
end

function window_size()
    local w, h = 520, 520
    mp.set_property("geometry", string.format("%dx%d", w, h))
end

function window_focus()
    local focused = mp.get_property("focused")
    mp.set_property("pause", focused == "no" and "yes" or "no")
end

function timestamp(seconds)
    local minutes = math.floor(seconds / 60)
    local seconds = seconds % 60
    return string.format("%02d:%02d", minutes, seconds)
end

function statusline()
    local duration = mp.get_property_number('duration')
    local time_pos = mp.get_property_number('time-pos')
    local ass0 = mp.get_property_osd("osd-ass-cc/0")
    local ass1 = mp.get_property_osd("osd-ass-cc/1")

    if duration and time_pos then
        local max_w = 28
        local fill_w = math.floor(max_w * (time_pos / duration))
	local data = "{\\an2}"

   --[[    heart strings
        .. "{\\fnCozetteVector\\fs16}"
        .. "{\\c&H94B5E0&\\3c&H687488&}"
        .. "‎‎‎"
        .. string.rep(" ", 21)
        .. "‧₊˚ ♡ ˚₊‧⁺˖"
        .. "\n\n"
   --]]
	-- progress bar
        .. "{\\fnCozetteVector\\fs16}"
        .. "{\\c&H92A1B5&\\3c&H687488&}"
        .. string.rep("▓", fill_w) .. "░"
	.. "{\\c&Hc3d3e2&}"
        .. string.rep("▒", max_w - fill_w)
	.. "\n\n"

	-- other details, timestamp
        .. "{\\fnScientifica\\fs18}"
	.. "{\\c&Hafcc94&\\3c&H687488&}"
        .. "🔋 93%" .. string.rep(" ", 4)
        .. "{\\c&Hc3d3e2&\\3c&H687488&}"
        .. string.format("%s / %s", "⏺️"
	.. timestamp(time_pos), timestamp(duration))

        mp.osd_message(ass0 .. data .. ass1, 9999)
    end
end

function main()
    if not file_extension(mp.get_property("path")) then
        mp.set_property("video-pan-y", "-0.15")
        mp.set_property("video-zoom", "-0.6")
    else
        mp.set_property("video-pan-y", "-0.38")
        mp.set_property("video-zoom", "-0.1")
        mp.set_property("video-aspect", "1920:1080")
    end

    window_size()
    --[[  uncomment the oommand below if you want to
          have the video paused when window is unfocused
    --]]
    -- mp.observe_property("focused", "string", window_focus)
    mp.observe_property("duration", "number", statusline)
    mp.observe_property("time-pos", "number", statusline)
end

mp.register_event("file-loaded", main)
