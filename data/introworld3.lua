local data = {}

data.background = { 215, 215, 215 }

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
  { x = 1400, destination = 'data.introworld', dx = 50 }
}

data.triggers = {}

function data.triggers.onEnter(context)
  context.showMessage('don\'t you know it\s dangerous?', 10)
end

return data
