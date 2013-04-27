local data = {}

data.lines = {
  0, 200,
  100,200,
  300,230,
  400,230
}

data.switches = {
  { name = 'switch', x = 350, gvar = 'emptyroom.switch' }
}

data.triggers = {}

function spawnExitPortal(context)
  context.addPortal(50, 'data.introworld', 984)
end

function data.triggers.onEnter(context)
  if context.getVar('emptyroom.switch') then
    spawnExitPortal(context)
  end
end

function data.triggers.onSwitchChanged(context, s)
  spawnExitPortal(context)
end

return data
