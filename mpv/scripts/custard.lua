--[[  License: The MIT License (MIT)
      Source: https://github.com/irhl/custard

      Fonts: CozetteVector, Scientifica

      PLEASE PAY ATTENTION
      before installing this script, there are
      a list of current issues you need to know.

      #2 23-10-2023 (Wayland)
      video playback delay
      when switching workspaces

      this isn't meant for normal use, it is
      intended for ricing and making art,
      so don't expect full functionality
      unless you pay me some pull requests
--]]

function window_size()
    local w, h = 520, 550
    mp.set_property('geometry', string.format('%dx%d', w, h))
end

function window_focus()
    local focused = mp.get_property('focused')
    mp.set_property('pause', focused == 'no' and 'yes' or 'no')
end

function file_extension(path)
    return string.match('mp4|mkv|webm',
    path:match('%.([^%.]+)$')) and true or false
end

function auto_subs()
    local playlist = mp.get_property_native('track-list')
    for _, track in ipairs(playlist) do
        if track.type == 'sub' then
            mp.set_property_number('sid', track.id)
            break
        end
    end
    mp.commandv('playlist-move', 'current', '+1')
end

function timestamp(seconds)
    local minutes = math.floor(seconds / 60)
    local seconds = seconds % 60
    return string.format('%02d:%02d', minutes, seconds)
end

function statusline()
    local ass0 = mp.get_property_osd('osd-ass-cc/0')
    local ass1 = mp.get_property_osd('osd-ass-cc/1')
    local time_stt = mp.get_property_native('pause')
    local time_pos = mp.get_property_number('time-pos')
    local duration = mp.get_property_number('duration')

    if duration and time_pos then
        local max_w = 28
        local fill_w = math.floor(max_w * (time_pos / duration))
        local data = '{\\an2}'

        -- progress bar
        .. '{\\fnCozetteVector\\fs16}'
        .. '{\\c&H92A1B5&\\3c&H687488&}'
        .. string.rep('▓', fill_w) .. '░'
        .. '{\\c&Hc3d3e2&}'
        .. string.rep('▒', max_w - fill_w)
        .. '\n\n'

        -- other details, timestamp
        .. '{\\fnScientifica\\fs18}'
	.. '{\\c&Hafcc94&\\3c&H687488&}'
        .. '🔋 93%' .. string.rep(' ', 4)
        .. '{\\c&Hc3d3e2&\\3c&H687488&}'
        .. string.format('%s / %s',
	   (time_stt == false and '⏺️' or '⏸️')
	.. timestamp(time_pos), timestamp(duration))
        .. '\n\n'

        mp.osd_message(ass0 .. data .. ass1, 9999)
    end
end

function main()
    attach_opts = {
        sub_font = 'Scientifica',
        sub_font_size = '26',
        sub_border_size = '0',
        sub_shadow_offset = '2',
        sub_shadow_color = '#e2d3c3',
        sub_color = '#776358',
        sub_pos = '75',
        sub_margin_x = '70',
        osc = 'no',
        osd_level = '0',
        osd_align_x = 'center',
        alpha = 'no',
        background = '#fbeedb',
        video_margin_ratio_top = '0.06',
        video_margin_ratio_left = '0.06',
        video_margin_ratio_right = '0.06',
        video_margin_ratio_bottom = '0.06',
    }
    attach_res = {
        low = {
            video_zoom = '-0.5',
            video_pan_y = '-0.15',
            video_aspect = '800:800',
        },
        high = {
            video_zoom = '-0.1',
            video_pan_y = '-0.42',
            video_aspect = '1920:1080',
        },
    }

    local mode = not file_extension(mp.get_property('path'))
        and 'low' or 'high'
    for _, tables in ipairs({attach_opts, attach_res[mode]}) do
        for opt, arg in pairs(tables) do
            mp.set_property('options/' .. opt:gsub('_', '-'), arg)
        end
    end

    auto_subs()
    window_size()

    --[[  uncomment the oommand below if you want to
          have the video paused when window is unfocused
    --]]
    -- mp.observe_property('focused', 'string', window_focus)
    mp.observe_property('duration', 'number', statusline)
    mp.observe_property('time-pos', 'number', statusline)
end

mp.register_event('file-loaded', main)
