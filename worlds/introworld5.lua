local data = {}

data.background = { 200, 200, 200 }

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
  { name = 'p1', x = 100, destination = 'introworld4', dx = 1350 },
  { name = 'p2', x = 700, destination = 'introworld5', dx = 1300 },
  { name = 'p3', x = 1300, destination = 'introworld6', dx = -50 }
}

data.switches = {
  { name = 'sw1', x = 248, ud = 'p1', gvar = 'introworld5.sw1' },
  { name = 'sw2', x = 448, ud = 'p2', gvar = 'introworld5.sw2' },
  --{ name = 'sw3', x = 948, ud = 'p3'  },
  { name = 'sw4', x = 1148, ud = 'p4',gvar = 'introworld5.sw4' }
}

data.triggers = {}
function data.triggers.onEnter(context)
  if context.getVar('puzzleworld1.solved') then
    context.removePortal('p2')
    
    local silent = true
    if not context.getVar('pwsound.playonce') then
      context.setVar('pwsound.playonce', true)
      silent = false
    end
    context.addPortal('pwsound', 700, 'pwsound_entry', -100, silent)
  end
end

function data.triggers.onSwitchChanged(context, s)
  if s.name == 'sw1' then
    context.showMessage('hohoho i warned you', 5)
  elseif s.name == 'sw2' then
    context.showMessage('now what will you do?', 5)
  elseif s.name == 'sw4' then
    context.showMessage('...false alarm', 5)
  end
  context.removePortal(s.ud)
end

return data
