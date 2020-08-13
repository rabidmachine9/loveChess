require 'Piece'
local array = require 'lib.array'

Bishop = Piece:new()

Bishop.hasMoved = false
Bishop.type = 'bishop'
Bishop.points = 3



function Bishop:getPossibleMoves()
	self.possibleMoves = {}

	self.possibleMoves = array.concat(self.possibleMoves, self:infiniteRightUpMoves(self.square))
	self.possibleMoves = array.concat(self.possibleMoves, self:infiniteLeftUpMoves(self.square))
	self.possibleMoves = array.concat(self.possibleMoves, self:infiniteLeftBackwardsMoves(self.square))
	self.possibleMoves = array.concat(self.possibleMoves, self:infiniteRightBackwardsMoves(self.square))

	return self.possibleMoves
end

return Bishop