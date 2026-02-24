-- Register message handler
mp.register_script_message('uosc-version', function(version)
  print('uosc version', version)
end)

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

  local timestamp = format_timestamp(mp.get_property_number("time-pos"))

  mp.commandv('run', 'wl-copy', timestamp)

  mp.osd_message(string.format('%s - timestamp copied to clipboard', timestamp))
  print(string.format('%s - timestamp copied to clipboard', timestamp))
end

local function copy_filename()
  local filename = mp.get_property("filename")
  mp.commandv('run', 'wl-copy', filename)

  mp.osd_message(string.format('%s - filename copied to clipboard', filename))
  print(string.format('%s - filename copied to clipboard', filename))
end

local function show_date_time()
  local date_time = os.date("%Y-%m-%d %H:%M:%S")
  mp.osd_message(date_time)
  print(date_time)
end

mp.add_key_binding("ctrl+t", "copy_timestamp", copy_timestamp)
mp.add_key_binding("ctrl+f", "copy_filename", copy_filename)
mp.add_key_binding("d", "show_date_time", show_date_time)
