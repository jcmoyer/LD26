local sound = {}

local newSource = love.audio.newSource
local stop = love.audio.stop
local play = love.audio.play

sound.switch = newSource('data/switch.ogg', 'static')
sound.portal = newSource('data/Portal.ogg', 'static')

sound.shift05 = newSource('data/Shifting05.ogg', 'static')
sound.shift10 = newSource('data/Shifting10.ogg', 'static')
sound.shift15 = newSource('data/Shifting15.ogg', 'static')
sound.shift20 = newSource('data/Shifting20.ogg', 'static')

sound.death = newSource('data/death.ogg', 'static')

function sound.restart(snd)
  stop(snd)
  play(snd)
end

function sound.pickShiftingSound(magnitude)
  if magnitude < 5 then
    return sound.shift05
  elseif magnitude < 10 then
    return sound.shift10
  elseif magnitude < 15 then
    return sound.shift15
  else
    return sound.shift20
  end    
end

return sound