local mp = require 'mp'

local opts = {
  alpha = 'no',
  background = '#fbeedb',
  sub_color = '#776358',
  sub_border_size = '0',
  sub_shadow_color = '#e2d3c3',
  sub_shadow_offset = '2',
  sub_font = 'Scientifica',
  sub_font_size = '28',
  sub_margin_x = '120',
  sub_pos = '75',
  sub_auto = 'all',

  osc = 'no',
  osd_level = '0',
  osd_align_x = 'center',

  video_margin_ratio_top = '0.06',
  video_margin_ratio_left = '0.06',
  video_margin_ratio_right = '0.06',
  video_margin_ratio_bottom = '0.06',
}

local reply = function()
  for opt, arg in pairs(opts) do
    mp.set_property('options/' .. opt:gsub('_', '-'), arg)
  end
end

return reply ()
