local data = {}

data.background = { 185, 185, 185 }

data.lines = {
  0, 300,
  200, 300,
  248, 300,
  300, 300,
  400, 325,
  448, 325,
  500, 325,
  600, 350,
  800, 350,
  900, 325,
  948, 325,
  1000, 325,
  1100, 300,
  1148, 300,
  1200, 300,
  1400, 300
}

data.portals = {
  { x = 100, destination = 'data.introworld5', dx = 700 },
  { x = 700, destination = 'data.introworld5', dx = 1300 },
  { x = 1300, destination = 'data.introworld5', dx = 100 }
}

data.switches = {
  { name = 'sw1', x = 248  },
  { name = 'sw2', x = 448 },
  { name = 'sw3', x = 948 },
  { name = 'sw4', x = 1148 }
}

return data
