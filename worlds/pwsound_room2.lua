local data = {}

data.lines = {
  0, 0,
  100, 0,
  200, 0,
  200, 4,
  208, 4,
  208, 8,
  216, 8,
  216, 12,
  224, 12,
  224, 16,
  232, 16,
  232, 20,
  240, 20,
  240, 24,
  248, 24,
  248, 28,
  252, 28,
  256, 28,
  356, 28,
  456, 28,
  456, 24,
  464, 24,
  464, 20,
  472, 20,
  472, 16,
  480, 16,
  480, 12,
  488, 12,
  488, 8,
  496, 8,
  496, 4,
  504, 4,
  504, 0,
  512, 0,
  612, 0,
  712, 0
}

data.portals = {
  { x = 100, destination = 'pwsound_room1', dx = 612 },
  { x = 612, destination = 'pwsound_room3', dx = 100 }
}

data.switches = {
  { x = 356 }
}

data.triggers = {}

function data.triggers.onSwitchChanged(context, s)
  context.playSound(context.getVar('pwsound_2'))
end

return data