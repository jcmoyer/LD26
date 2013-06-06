local data = {}

data.lines = {
  -138, 11,
  -68, 11,
  2, 11,
  178, 31,
  364, 49,
  468, 55,
  591, 68,
  664, 99,
  724, 140,
  772, 162,
  850, 185,
  891, 185,
  964, 185,
  999, 177,
  1034, 158,
  1078, 131,
  1121, 103,
  1165, 86,
  1217, 75,
  1260, 67,
  1299, 64,
  1477, 54,
  1527, 53,
  1566, 52,
  1610, 53,
  1736, 53,
  1842, 53
}
data.portals = {
  { x = -68, destination = 'data.puzzleworld2', dx = -156 },
  { x = 891, destination = 'data.puzzleworld2_1_1', dx = 482 },
  { x = 1736, destination = 'data.puzzleworld2_2_2', dx = -100 }
}
data.enemies = {
  { x = 178, patrol = { left = 178, right = 591 }, size = 5 }
}

data.triggers = {}
function data.triggers.onPlayerDeath(context)
  context.changeWorld('data.puzzleworld2', -156)
end

return data
