local data = {}

data.background = { 215, 215, 215 }

data.lines = {
  0,   300,
  2000,300
}

data.portals = {
  { x = 1400, destination = 'data.introworld', dx = 50 }
}

data.triggers = {}

function data.triggers.onEnter(context)
  context.showMessage('don\'t you know it\s dangerous?', 10)
end

return data
