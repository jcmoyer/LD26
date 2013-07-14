local timerpool = {}
local timers = {}

local remove = table.remove

function timerpool.start(duration, callback)
  local remaining = duration
  local timer = {}
  function timer.getCallback()
    return callback
  end
  function timer.getRemaining()
    return remaining
  end
  function timer.getDuration()
    return duration
  end
  function timer.update(dt)
    remaining = remaining - dt
  end
  function timer.finished()
    return remaining <= 0
  end
  
  timers[#timers + 1] = timer
  
  return timer
end

function timerpool.update(dt)
  for i = #timers, 1, -1 do
    local t = timers[i]
    t.update(dt)
    if t.finished() then
      local f = t.getCallback()
      if f then f() end
      remove(timers, i)
    end
  end
end

return timerpool