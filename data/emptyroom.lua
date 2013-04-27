local data = {}

data.lines = {
  0, 200,
  100,200,
  300,230,
  400,230
}

data.portals = {
  { x = 50, destination = 'data.introworld', dx = 984 }
}

data.regions = {
  { name = 'switch', x = 350, w = 16 }
}

data.triggers = {}

function data.triggers.onEnterRegion(context, r)
  if r.name == 'switch' then
    context.setVar('emptyroom.switch', true)
  end
end

function data.triggers.onDraw(context)
  local g = love.graphics
  local switchReg = data.regions[1]
  local status    = context.getVar('emptyroom.switch')
  if status then
    local hw = switchReg.w / 2
    local y  = context.y(switchReg.x)
    g.setColor(context.preferredColor())
    g.rectangle('fill', switchReg.x - hw, y - 2, switchReg.w, 2)
  else
    local hw = switchReg.w / 2
    local y  = context.y(switchReg.x)
    g.setColor(context.preferredColor())
    g.rectangle('fill', switchReg.x - hw, y - 8, switchReg.w, 8)
  end
end

return data
