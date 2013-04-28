local data = {}

data.lines = {
  0, 300,
  -- 50: Switch 1
  100, 300,
  200, 325,
  300, 325,
  400, 300,
  -- 450: Switch 2
  500, 300,
  600, 325,
  650, 325, -- Spawn player HERE
  700, 325,
  800, 300,
  -- 850: Switch 3
  900, 300,
  1000, 325,
  1100, 325,
  1200, 300,
  -- 1250: Switch 4
  1300, 300
}

data.portals = {
  { x = 650 , destination = 'data.introworld3', dx = 650  },
  { x = 250 , destination = 'data.iw3r1'      , dx = 1050 },
  { x = 1050, destination = 'data.iw3r1'      , dx = 250  }
}

data.switches = {
  { name = 'sw1', x = 50   , ud = 1 },
  { name = 'sw2', x = 450  , ud = 2 },
  { name = 'sw3', x = 850  , ud = 3 },
  { name = 'sw4', x = 1250 , ud = 4 }
}

data.triggers = {}

function setAllSwitches(context, status)
  for _,v in ipairs(data.switches) do
    context.setSwitchStatus(v.name, status)
  end
end

function data.triggers.onEnter(context)
  if not context.getVar('iw3r1') then
    context.showMessage('no seriously', 5)
    context.setVar('iw3r1', true)
  end
  if context.getVar('introworld3.continue') then
    setAllSwitches(context, true)
  end
end

-- Correct order is 3-1-4-2
local switchIndex = 1
local switchOrder = { 3, 1, 4, 2 }
function data.triggers.onSwitchChanged(context, s)
  if switchOrder[switchIndex] == s.ud then
    switchIndex = switchIndex + 1
    if switchIndex > #switchOrder then
      context.shakeCamera(5, 5)
      context.showMessage('stop that', 10)
      context.setVar('introworld3.continue', true)
    end
  else
    -- wrong choice
    setAllSwitches(context, false)
    switchIndex = 1
  end
end

return data
