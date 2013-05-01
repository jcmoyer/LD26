local data = {}

data.lines = {
  -608, -604,
  -600, -604,
  -600, -600,
  -600, -300,
  -450, -300,
  0, -300,
  0, 0,
  100, 0,
  400, 0,
  400, 300,
  550, 300,
  700, 300,
  700, 0,
  800, 0,
  900, 0,
  900, 200,
  1050, 200,
  1200, 200,
  1200, -300,
  1650, -300,
  1800, -300,
  1800, -900,
  1900, -900,
  2000, -900,
  2100, -900,
  2200, -900,
  2200, -1500,
  2200, -1504,
  2208, -1504
}
data.portals = {
  { x = 100, destination = 'data.puzzleworld1', dx = 650 },
  { x = 325, destination = 'data.puzzleworld1_3', dx = 800 },
  { x = 800, destination = 'data.puzzleworld1_3', dx = 1650 },
  { x = 550, destination = 'data.puzzleworld1_3', dx = 325 },
  { x = 1050, destination = 'data.puzzleworld1_3', dx = 2100 },
  { x = 1650, destination = 'data.puzzleworld1_3', dx = 325 },
  { x = -450, destination = 'data.puzzleworld1_3', dx = 100 },
  { x = 1312, destination = 'data.puzzleworld1_3', dx = -450 },
  { x = -225, destination = 'data.puzzleworld1_3', dx = 550 },
  { x = -337, destination = 'data.puzzleworld1_3', dx = 1050 },
  { x = -112, destination = 'data.puzzleworld1_3', dx = 550 },
  { x = 2100, destination = 'data.puzzleworld1_3', dx = 1650 },
}

--[[
  { x = -112, destination = 'TODO', dx = 0 },
  { x = -337, destination = 'TODO', dx = 0 },
  { x = -225, destination = 'TODO', dx = 0 }
]]--

data.enemies = {
  { x = 2200 },
  { x = 2201 },
  { x = 1801 },
  { x = 1800 },
  { x = 1200 },
  { x = 1201 },
  { x = -600 },
  { x = -599 },
  { x = 400  },
  { x = 401  },
  { x = 0    },
  { x = 1    },
  { x = 900  },
  { x = 901  },
  { x = 700  },
  { x = 701  },
}

data.switches = {
  { name = 'clear', x = 1900 }
}

data.triggers = {}

function data.triggers.onEnter(context)
  if not context.getVar('puzzleworld1_3.entered') then
    context.showMessage("surely you'll get lost in my labyrinth", 10)
    context.setVar('puzzleworld1_3.entered', true)
  end
end

function data.triggers.onPlayerDeath(context)
  context.changeWorld('data.puzzleworld1', 650)
end

function data.triggers.onSwitchChanged(context, s)
  context.addPortal('clear', 2000, 'data.puzzleworld1', 650)
  if not context.getVar('puzzleworld1_3.solved') then
    context.setVar('puzzleworld1_3.solved', true)
    context.shakeCamera(5, 15)
    context.showMessage('nooooooooooo!!', 5)
  end
end

return data
