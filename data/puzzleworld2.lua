local data = {}

data.lines = {
  -512, 0,
  -412, 0,
  -312, 0,
  -304, 0,
  -304, -4,
  -296, -4,
  -296, -8,
  -288, -8,
  -288, -12,
  -280, -12,
  -280, -16,
  -272, -16,
  -272, -20,
  -264, -20,
  -264, -24,
  -256, -24,
  -256, -26,
  -256, -28,
  -156, -28,
  -56, -28,
  -48, -28,
  -48, -24,
  -40, -24,
  -40, -20,
  -32, -20,
  -32, -16,
  -24, -16,
  -24, -12,
  -16, -12,
  -16, -8,
  -8, -8,
  -8, -4,
  0, -4,
  0, 0,
  200, 0,
  200, -4,
  208, -4,
  208, -8,
  216, -8,
  216, -12,
  224, -12,
  224, -16,
  232, -16,
  232, -20,
  240, -20,
  240, -24,
  248, -24,
  248, -28,
  252, -28,
  256, -28,
  356, -28,
  456, -28,
  456, -24,
  464, -24,
  464, -20,
  472, -20,
  472, -16,
  480, -16,
  480, -12,
  488, -12,
  488, -8,
  496, -8,
  496, -4,
  504, -4,
  504, 0,
  512, 0,
  612, 0,
  712, 0
}

data.portals = {
  { x = -412, destination = 'data.puzzleworld2_1_1', dx = -45 },
  { x = -156, destination = 'data.puzzleworld2_2_1', dx = -68 },
  { x = 356, destination = 'data.puzzleworld2_3_1', dx = 62 },
  { x = 612, destination = 'data.puzzleworld2_4_1', dx = 62 },

  -- Entry portal
  { x = 100, destination = 'data.treasureroom', dx = 980 }
}

data.triggers = {}
function data.triggers.onEnter(context)
  if not context.getVar('puzzleworld2.entered') then
    context.showMessage('these puzzles will be the end of you', 10)
    context.setVar('puzzleworld2.entered', true)
  end
end

return data
