local basicgame = require('core.basicgame')
local menustate = require('states.menustate')

basicgame.start(menustate.new(), true)
