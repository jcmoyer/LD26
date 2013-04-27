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
  1300, 450
}

data.portals = {
  { x = 150, destination = 'data.testroom', dx = 600 },
  { x = 250, destination = 'data.introworld', dx = 600 },
  { x = 600, destination = 'data.introworld', dx = 250 }
}

return data
