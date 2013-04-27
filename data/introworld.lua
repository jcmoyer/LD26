local data = {}

data.background = { 255, 255, 255 }

data.lines = {
  0,   300,
  300, 300,
  500, 290,
  550, 320,
  650, 320,
  700, 350,
  1000, 500,
  1300, 450,
  1500, 450
}

data.portals = {
  { x = 1400, destination = 'data.introworld2', dx = 50 }
}
data.regions = {
  { x = 300, w = 10 }
}

data.triggers = {}

function data.triggers.onEnter(context)
  context.showMessage('hey', 5)
end

function data.triggers.onEnterRegion(context, r)
  context.showMessage('in region', 5)
end

return data
