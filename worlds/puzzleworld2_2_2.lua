local data = {}

data.lines = {
  -200, 0,
  -100, 0,
  0, 0,
  145, -11,
  252, -30,
  303, -50,
  360, -81,
  385, -98,
  418, -116,
  447, -129,
  490, -145,
  519, -156,
  554, -166,
  599, -177,
  634, -181,
  654, -180,
  677, -173,
  742, -154,
  774, -143,
  822, -126,
  899, -105,
  980, -94,
  1016, -98,
  1054, -104,
  1087, -113,
  1124, -115,
  1162, -110,
  1209, -109,
  1243, -101,
  1309, -97,
  1372, -106,
  1447, -106,
  1529, -106,
  1564, -111,
  1590, -107,
  1625, -103,
  1690, -100,
  1737, -108,
  1806, -121,
  1834, -130,
  1869, -149,
  1910, -164,
  1943, -160,
  1972, -151,
  1992, -137,
  2044, -117,
  2080, -114,
  2129, -119,
  2156, -125,
  2184, -132,
  2212, -132,
  2240, -132,
  2292, -124,
  2349, -111,
  2376, -112,
  2429, -113,
  2462, -115,
  2525, -117,
  2700, -117
}

data.portals = {
  { x = -100, destination = 'data.puzzleworld2_2_1', dx = 1736 },
  { x = 2612, destination = 'data.puzzleworld2_1_2', dx = 1971 }
}
data.enemies = {
  { x = 1910, patrol = { left = 1910, right = 2129 } },
}
data.switches = {
  { name = 'rightsw', x = 2212, gvar = 'puzzleworld2_2_2.switch' }
}

data.triggers = {}

function spawnFinalRoomPortal(context, silent)
  context.addPortal('final', 1447, 'data.puzzleworld2_2_3', 62, silent)
end

function data.triggers.onPlayerDeath(context)
  context.changeWorld('data.puzzleworld2', -156)
end

function data.triggers.onEnter(context)
  if context.getVar('puzzleworld2_2_2.switch') then
    spawnFinalRoomPortal(context, true)
  end
end

function data.triggers.onSwitchChanged(context, s)
  if s.name == 'rightsw' then
    spawnFinalRoomPortal(context, false)
  end
end

return data
