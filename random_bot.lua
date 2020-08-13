local array = require 'lib.array'
local inspect = require 'lib.inspect'


RandomBot = {}

RandomBot.posibleMoves = {}


function RandomBot:getPossibleMoves()
	posibleMoves = {}

	for i,p in ipairs(Pieces) do
		local moves = p:getPossibleMoves()
		posibleMoves = array.concat(movesl, self.posibleMoves)
	end

	return posibleMoves
end

