local data = {}

data.lines = {
  -396, -48,
  -296, -48,
  -288, -48,
  -288, -44,
  -280, -44,
  -280, -40,
  -272, -40,
  -272, -36,
  -264, -36,
  -264, -32,
  -164, -32,
  -156, -32,
  -156, -28,
  -148, -28,
  -148, -24,
  -140, -24,
  -140, -20,
  -132, -20,
  -132, -16,
  -- -82 portal or enemy?
  -32, -16,
  -24, -16,
  -24, -12,
  -16, -12,
  -16, -8,
  -8, -8,
  -8, -4,
  0, -4,
  0, 0,
  50, 0,
  100, 0,
  100, -4,
  108, -4,
  108, -8,
  116, -8,
  116, -12,
  124, -12,
  124, -16,
  132, -16,
--182 portal
  232, -16,
  232, -20,
  240, -20,
  240, -24,
  248, -24,
  248, -28,
  256, -28,
  256, -32,
  264, -32,
  364, -32,
  364, -36,
  372, -36,
  372, -40,
  380, -40,
  380, -44,
  388, -44,
  388, -48,
  396, -48,
  496, -48
}

data.portals = {
  { x = 50, destination = 'puzzleworld1', dx = 250 },
  { name = 'pl', x = -214, destination = 'puzzleworld1_1', dx = 182 },
  { name = 'pr', x = 182, destination = 'puzzleworld1_1', dx = -214 }
}

data.enemies = {
  { x = -82, patrol = { left = -264, right = -32 }, size = 2, speed = 250 },
  { x = 264, patrol = { left = 100, right = 480 } }
}

data.switches = {
  { name = 'swl', x = -346 },
  { name = 'swr', x = 446 }
}

data.triggers = {}
function data.triggers.onEnter(context)
  if not context.getVar('puzzleworld1_1.entered') then
    context.showMessage('these guys will make short work of you', 10)
    context.setVar('puzzleworld1_1.entered', true)
  end
  if context.getVar('puzzleworld1_1.solved') then
    context.setSwitchStatus('swl', true)
    context.setSwitchStatus('swr', true)
  end
end

function data.triggers.onPlayerDeath(context)
  context.changeWorld('puzzleworld1', 250)
end

local switchTimers = {}

function data.triggers.onSwitchChanged(context, s)
  switchTimers[s.name] = 5

  local lstat = context.getSwitchStatus('swl')
  local rstat = context.getSwitchStatus('swr')
  if lstat and rstat then
    context.setVar('puzzleworld1_1.solved', true)
    context.shakeCamera(5, 5)
  end
end

function data.triggers.onUpdate(context, dt)
  if context.getVar('puzzleworld1_1.solved') then return end
  for k,v in pairs(switchTimers) do
    local t = switchTimers[k] - dt
    switchTimers[k] = t
    if (t <= 0 and context.getSwitchStatus(k)) then
      context.playSwitchSound()
      context.setSwitchStatus(k, false)
    end
  end
end

return data
