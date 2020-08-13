require 'Piece'
local array = require 'lib.array'

Queen = Piece:new()


Queen.hasMoved = false
Queen.type = 'queen'
Queen.points = 9



function Queen:getPossibleMoves()
	self.possibleMoves = {}

	self.possibleMoves = array.concat(self.possibleMoves, self:infiniteForwardMoves(self.square))
	self.possibleMoves = array.concat(self.possibleMoves, self:infiniteRightMoves(self.square))
	self.possibleMoves = array.concat(self.possibleMoves, self:infiniteLeftMoves(self.square))
	self.possibleMoves = array.concat(self.possibleMoves, self:infiniteBackwardsMoves(self.square))

	self.possibleMoves = array.concat(self.possibleMoves, self:infiniteRightUpMoves(self.square))
	self.possibleMoves = array.concat(self.possibleMoves, self:infiniteLeftUpMoves(self.square))
	self.possibleMoves = array.concat(self.possibleMoves, self:infiniteLeftBackwardsMoves(self.square))
	self.possibleMoves = array.concat(self.possibleMoves, self:infiniteRightBackwardsMoves(self.square))

	return self.possibleMoves
end


return Queen