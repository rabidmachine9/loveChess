require 'Piece'
local array = require 'lib.array'


Tower = Piece:new()


Tower.hasMoved = false
Tower.type = 'tower'
Tower.symbol = 'r'
Tower.points = 5


function Tower:getPossibleMoves()
	self.possibleMoves = {}


	local forwardMoves = self:infiniteForwardMoves(self.square)
	local rightMoves = self:infiniteRightMoves(self.square)
	local leftMoves = self:infiniteLeftMoves(self.square)
	local backwardsMoves = self:infiniteBackwardsMoves(self.square)

	self.possibleMoves = array.concat(forwardMoves,rightMoves)
	self.possibleMoves = array.concat(self.possibleMoves, leftMoves)
	self.possibleMoves = array.concat(self.possibleMoves, backwardsMoves)


	return self.possibleMoves
end






return Tower
