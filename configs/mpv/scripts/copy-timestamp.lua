local function copy_timestamp()

  local function format_timestamp(t)
    local s_ms = t % 60
    local r = t - s_ms
    local h = math.floor(r / 3600)
    r = r - (h * 3600)
    local m = r / 60
    local s, ms = string.format('%.03f', s_ms):match('([^.]*).(.*)')
    return string.format('%02d:%02d:%02d', h, m, s)
  end

  local time = format_timestamp(mp.get_property_number("time-pos"))

  mp.commandv('run', 'cmd', '/D', '/C', 'echo', time, '|', 'clip')

  mp.osd_message(string.format('%s - timestamp copied to clipboard', time))
  print(string.format('%s - timestamp copied to clipboard', time))

end

mp.add_key_binding("ctrl+t", "copy_timestamp", copy_timestamp)
