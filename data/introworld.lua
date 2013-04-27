local data = {}

data.lines = {
  100, 300,
  200, 350,
  400, 290,
  500, 350,
  800, 500,
  1000, 400
}

data.portals = {
  { x = 150, destination = 'data.testroom', dx = 600 },
  { x = 250, destination = 'data.introworld', dx = 600 },
  { x = 600, destination = 'data.introworld', dx = 250 }
}

return data
