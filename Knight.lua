require 'Piece'
local array = require 'lib.array'
local inspect = require 'lib.inspect'


Knight = Piece:new()


Knight.hasMoved = false
Knight.type = 'knight'
Knight.points = 3


function Knight:getPossibleMoves()
	self.possibleMoves = {}

	local oneLeft = self:moveLeft()
	local twoLeft = self:moveLeft(oneLeft)

	if twoLeft ~= nil and oneLeft ~= nil then
		self.possibleMoves = array.concat(self.possibleMoves, self:_upDown(twoLeft))
	end

	local oneRight = self:moveRight()
	local twoRight = self:moveRight(oneRight)

	if twoRight ~= nil and oneRight ~= nil then
		self.possibleMoves = array.concat(self.possibleMoves, self:_upDown(twoRight))
	end

	local oneForward = self:moveForward()
	local twoForward = self:moveForward(oneForward)

	if twoForward ~= nil and oneForward ~= nil then
		self.possibleMoves = array.concat(self.possibleMoves, self:_leftRight(twoForward))
	end

	local oneBack = self:moveBackwards()
	local twoBack = self:moveBackwards(oneBack)

	if twoBack ~= nil and oneBack ~= nil then
		self.possibleMoves = array.concat(self.possibleMoves, self:_leftRight(twoBack))
	end


	self.possibleMoves = array.filter(self.possibleMoves, function(square)
			return self.color ~= chessBoard:colorOfPieceInSquare(square)
		end
	)


	
	return self.possibleMoves
end

function Knight:_upDown(square)
	local moves = {}

	table.insert(moves, self:moveForward(square))
	table.insert(moves, self:moveBackwards(square))
	return moves
end


function Knight:_leftRight(square)
	local moves = {}

	table.insert(moves, self:moveLeft(square))
	table.insert(moves, self:moveRight(square))

	return moves
end 

return Knight