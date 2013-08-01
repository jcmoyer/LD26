local time = {}

local floor = math.floor
local format = string.format

function time.str(t)
  local sec = floor(t)
  local frac = t - sec
  local min = floor(sec / 60)
  local hr  = floor(min / 60)
  return format('%02d:%02d:%02d.%03d', hr, min % 60, sec % 60, frac * 1000)
end

return time