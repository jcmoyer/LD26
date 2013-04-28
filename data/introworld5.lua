local data = {}

background = { 185, 185, 185 }

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
  { x = 25 *4, destination = 'data.introworld5', dx = 175*4 },
  { x = 175*4, destination = 'data.introworld5', dx = 325*4 },
  { x = 325*4, destination = 'data.introworld5', dx = 25 *4 }
}

data.switches = {
  { name = 'sw1', x = 62*4  },
  { name = 'sw2', x = 112*4 },
  { name = 'sw3', x = 237*4 },
  { name = 'sw4', x = 287*4 }
}

return data
