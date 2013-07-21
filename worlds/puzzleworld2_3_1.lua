local data = {}

data.lines = {
  0, 0,
  62, 0,
  125, 0,
  187, 0,
  250, 0,
  375, 0,
  500, 0,
  500, -500,
  1000, -500
}

data.portals = {
  { x = 62, destination = 'puzzleworld2', dx = 356 },
  { x = 900, destination = 'puzzleworld2_3_2', dx = -100 }
}

data.enemies = {
  { x = 500 },
  { x = 501 }
}

data.triggers = {}
function data.triggers.onEnter(context)
  context.showMessage('nothing to see here', 5)
end

function data.triggers.onPlayerDeath(context)
  context.changeWorld('puzzleworld2', 100)
end

return data
