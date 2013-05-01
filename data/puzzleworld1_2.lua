local data = {}

data.lines = {
  -200, 0,
  0, 0,
  100, 0,
  200, 0,
  212, 12,
  216, 30,
  240, 34,
  256, 56,
  265, 62,
  267, 72,
  292, 82,
  303, 101,
  306, 110,
  325, 129,
  344, 141,
  352, 146,
  362, 162,
  375, 175,
  387, 187,
  400, 200,
  428, 200,
  450, 200,
  475, 185,
  500, 185,
  525, 185,
  550, 200,
  600, 200,
  612, 192,
  618, 179,
  639, 163,
  652, 158,
  672, 126,
  678, 119,
  685, 106,
  694, 93,
  712, 83,
  719, 73,
  731, 69,
  746, 47,
  762, 40,
  775, 25,
  787, 12,
  800, 0,
  900, 0,
  1500, 0
}


data.portals = {
  { x = 850, destination = 'data.puzzleworld1_2', dx = 1350 },
  --{ x = 900, destination = 'data.puzzleworld1_2', dx = 950 },
  --{ x = 950, destination = 'data.puzzleworld1_2', dx = 1000 },
  --{ x = 1000, destination = 'data.puzzleworld1_2', dx = 1050 },
  --{ x = 1050, destination = 'data.puzzleworld1_2', dx = 1100 },
  --{ x = 1100, destination = 'data.puzzleworld1_2', dx = 1150 },
  --{ x = 1150, destination = 'data.puzzleworld1_2', dx = 1200 },
  --{ x = 1200, destination = 'data.puzzleworld1_2', dx = 1250 },
  --{ x = 1250, destination = 'data.puzzleworld1_2', dx = 1300 },
  --{ x = 1300, destination = 'data.puzzleworld1_2', dx = 1350 },
  { x = 1350, destination = 'data.puzzleworld1_2', dx = 850 },
  --{ x = 1400, destination = 'data.puzzleworld1_2', dx = 850 }
}

data.switches = {
  { name = 's1', x = -25, ud = 1 },
  { name = 's2', x = 25 , ud = 1 },
  { name = 's3', x = 75 , ud = 1 },
  { name = 's4', x = 125, ud = 1 },
  { name = 's5', x = 175, ud = 1 },

  { name = 'p2s3', x = 925, ud = 2 },
  { name = 'p2s4', x = 975, ud = 2 },
  { name = 'p2s6', x = 1075, ud = 2 },
  { name = 'p2s7', x = 1125, ud = 2 },
  { name = 'p2s8', x = 1175, ud = 2 },
  { name = 'p2s10', x = 1275, ud = 2 },
  { name = 'p2s11', x = 1325, ud = 2 },
  
  { name = 'p3s1', x = 425, ud = 3 },
  { name = 'p3s2', x = 575, ud = 3 }
}

data.enemies = {
  -- Left slope guards
  { x = 205, patrol = { left = 205, right = 395 }, size = 1.5, speed = 110 },
  { x = 265, patrol = { left = 221, right = 355 }, size = 1.1, speed = 140 },
  { x = 305, patrol = { left = 250, right = 315 }, size = 0.5, speed = 150 },
  -- Right slope guards
  { x = 650, patrol = { left = 605, right = 780 }, size = 3, speed = 30 }
  --{ x = 305, patrol = { left = 250, right = 315 }, size = 0.5, speed = 150 }
}

data.triggers = {}
local switchStack = {}
local p3Sequence = {}
local switchTimers = {}

function data.triggers.onEnter(context)
  switchStack = {}
  p3Sequence = {}
  switchTimers = {}
  if not context.getVar('puzzleworld1_2.entered') then
    context.showMessage('i hope you like switches as much as i do', 10)
    context.setVar('puzzleworld1_2.entered', true)
  end
end

function data.triggers.onUpdate(context, dt)
  for k,v in pairs(switchTimers) do
    local t = switchTimers[k] - dt
    switchTimers[k] = t
    if (t <= 0 and context.getSwitchStatus(k)) then
      context.playSwitchSound()
      context.setSwitchStatus(k, false)
    end
  end
end

function data.triggers.onEnterPortal(context, p)
  if p.name == 'part1' then
    context.showMessage('your life is about to get a lot harder', 10)
  elseif p.name == 'part2' then
    context.showMessage("you'll never guess the password", 10)
  end
  return true
end

function data.triggers.onPlayerDeath(context)
  context.changeWorld('data.puzzleworld1', 450)
end


function data.triggers.onSwitchChanged(context, s)
  if s.ud == 1 then
    processGroupOneSwitch(context, s)
  elseif s.ud == 2 then
    processGroupTwoSwitch(context, s)
  elseif s.ud == 3 then
    processGroupThreeSwitch(context, s)
  end
end

function processGroupOneSwitch(context, s)
  table.insert(switchStack, 1, s)
  if #switchStack > 3 then
    local last = table.remove(switchStack)
    context.setSwitchStatus(last.name, false)
  end

  local s2stat = context.getSwitchStatus('s2')
  local s3stat = context.getSwitchStatus('s3')
  local s5stat = context.getSwitchStatus('s5')
  if s2stat and s3stat and s5stat then
    context.addPortal('part1', -150, 'data.puzzleworld1_2', 850)
  end
end

function processGroupTwoSwitch(context, s)
  table.insert(switchStack, 1, s)
  if #switchStack > 3 then
    local last = table.remove(switchStack)
    context.setSwitchStatus(last.name, false)
  end

  local s6stat = context.getSwitchStatus('p2s6')
  local s7stat = context.getSwitchStatus('p2s7')
  local s10stat = context.getSwitchStatus('p2s10')
  if s6stat and s7stat and s10stat then
    context.addPortal('part2', 1450, 'data.puzzleworld1_2', 500)
  end
end

function processGroupThreeSwitch(context, s)
  switchTimers[s.name] = 1

  if s.name == 'p3s1' then
    table.insert(p3Sequence, 1, 1)
  elseif s.name == 'p3s2' then
    table.insert(p3Sequence, 1, 2)
  end

  if #p3Sequence > 4 then
    table.remove(p3Sequence)
  end
  if
    p3Sequence[1] == 1 and
    p3Sequence[2] == 2 and
    p3Sequence[3] == 2 and
    p3Sequence[4] == 1 then
    context.setVar('puzzleworld1_2.solved', true)
    context.shakeCamera(5, 10)
    context.addPortal('part3', 500, 'data.puzzleworld1', 450)
  end
end

return data
