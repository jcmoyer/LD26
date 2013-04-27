local data = {}

data.background = { 230, 230, 230 }

data.lines = {
  0,    0,
  100, 20,
  250, 50,
  400, 100,
  600, 100,
  700, 50,
  900, 0,
  1000, -50,
  1200, -50,
  1500, -100,
  1700, -100
}

data.portals = {
  { x = 1600, destination = 'data.introworld3', dx = 100 }
}

data.triggers = {}

function data.triggers.onEnter(context)
  context.showMessage('where are you going?', 10)
end

return data
