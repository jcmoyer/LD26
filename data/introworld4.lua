local data = {}

data.background = { 200, 200, 200 }

data.lines = {
  0, 300,
  92, 316,
  210, 349,
  285, 378,
  365, 419,
  449, 452,
  529, 527,
  577, 574,
  677, 652,
  748, 671,
  774, 679,
  787, 679,
  800, 679, -- portal here
  814, 679,
  828, 679,
  865, 687,
  901, 695,
  947, 695,
  995, 710,
  1037, 738,
  1085, 780,
  1144, 838,
  1170, 885,
  1217, 929,
  1276, 952,
  1300, 957,
  -- portal 1350
  1400, 957
}

data.portals = {
  { x = 800 , destination = 'data.introworld', dx = 0 },
  { x = 1350, destination = 'data.introworld', dx = 0 }
}



return data
