local timerpool = require('hug.timerpool')
local data = {}

data.lines = {
  0, 0,
  100, 0,
  200, 0,
  300, 0,
  400, 0,
  500, 0,
  600, 0,
  700, 0,
  800, 0,
  800, 4,
  808, 4,
  808, 8,
  816, 8,
  816, 12,
  824, 12,
  824, 16,
  832, 16,
  832, 20,
  840, 20,
  840, 24,
  848, 24,
  848, 28,
  856, 28,
  906, 28,
  956, 28
}

data.portals = {
  { x = 100, destination = 'pwsound_entry', dx = 356 }
}

data.switches = {
  { name = 'solve', x = 906 }
}

data.counters = {
  { name = '1', x = 300, min = 1, max = 4 },
  { name = '2', x = 400, min = 1, max = 4 },
  { name = '3', x = 500, min = 1, max = 4 },
  { name = '4', x = 600, min = 1, max = 4 }
}

data.triggers = {}

local sounds = {
  'squareC2',
  'squareC3',
  'squareC4',
  'squareC5'
}

function data.triggers.onEnter(context)
  if context.getVar('pwsound.solved') == true then
    context.setSwitchStatus('solve', true)
  end  
end

function data.triggers.onCounterChanged(context, counter)
  context.playSound(sounds[counter.value])
end

function data.triggers.onSwitchChanged(context, switch)
  local c1snd = sounds[context.getCounterValue('1')]
  local c2snd = sounds[context.getCounterValue('2')]
  local c3snd = sounds[context.getCounterValue('3')]
  local c4snd = sounds[context.getCounterValue('4')]
  
  if c1snd == context.getVar('pwsound_1') and
     c2snd == context.getVar('pwsound_2') and
     c3snd == context.getVar('pwsound_3') and
     c4snd == context.getVar('pwsound_4') then
    context.setVar('pwsound.solved', true)
    context.shakeCamera(5, 15)
  end
end

return data