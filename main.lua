-- Look for modules in lib/ directory
package.path = "./lib/?.lua;" .. package.path

local basicgame = require('hug.basicgame')
local menustate = require('states.menustate')

basicgame.start(menustate.new(), true)
