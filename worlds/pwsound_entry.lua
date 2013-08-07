local data = {}

data.lines = {
  -200, 0,
  -100, 0,
  0, 0,
  100, 0,
  200, 0,
  200, 4,
  208, 4,
  208, 8,
  216, 8,
  216, 12,
  224, 12,
  224, 16,
  232, 16,
  232, 20,
  240, 20,
  240, 24,
  248, 24,
  248, 28,
  252, 28,
  256, 28,
  356, 28,
  456, 28,
  456, 24,
  464, 24,
  464, 20,
  472, 20,
  472, 16,
  480, 16,
  480, 12,
  488, 12,
  488, 8,
  496, 8,
  496, 4,
  504, 4,
  504, 0,
  512, 0,
  612, 0,
  712, 0
}

data.portals = {
  -- enter here
  --{ x = -100, destination = 'TODO', dx = 0 },
  -- hint room 1
  { x = 100, destination = 'pwsound_room1', dx = 100 },
  -- solver room
  { x = 356, destination = 'pwsound_solve', dx = 100 },
  -- hint room 4
  { x = 612, destination = 'pwsound_room4', dx = 612 }
}

data.triggers = {}

function data.triggers.onEnter(context)
  if not context.getVar('pwsound_entry.entered') then
    -- generate sound pattern
    local soundpattern = {}
    for i = 1,4 do
      local name  = string.format('pwsound_%d', i)
      local sound = 'squareC' .. math.random(2, 5)
      context.setVar(name, sound)
    end
    context.setVar('pwsound_entry.entered', true)
  end
  
  if context.getVar('pwsound.solved') then
    local silent = true
    
    if not context.getVar('pwsound.playexitonce') then
      context.setVar('pwsound.playexitonce', true)
      silent = false
    end
    
    context.addPortal('next', -100, 'introworld5', 700, silent)
  end
end

return data