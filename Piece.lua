local inspect = require 'lib.inspect'
require 'Board'
local array = require 'lib.array'
Piece = {}

Piece.color = nil
Piece.x = nil
Piece.y = nil
Piece.grabFactor = 0
Piece.scaleFactor = nil
Piece.square = nil
Piece.column = nil
Piece.row = nil
Piece.grabed = false
Piece.possibleMoves = {}
Piece.image = love.graphics.newImage('images/pawn_w.png')
Piece.tempDead = false

function Piece:new(color,square,pieceType)
	local newPiece = {color = color, square = square, pieceType = pieceType }

	newPiece.color = color
	newPiece.square = square

	self.__index = self

	return setmetatable(newPiece, self)
end

function Piece:setPosition()
	if self.grabed == false then
		local squarePosition = Board:getSquareXY(self.square)
		self.x = squarePosition.x + ((Board.squareWidth - self.image:getWidth()) /2) + self.grabFactor
		self.y = squarePosition.y + ((Board.squareHeight - self.image:getHeight()) /2) + self.grabFactor
	else
		self.x = love.mouse.getX()
		self.y = love.mouse.getY()
	end
end

function Piece:getColumn(square)
	return (square == nil) and (self.square):sub(1,1) or square:sub(1,1)
end

function Piece:getRow(square)
	return (square == nil) and (self.square):sub(2,2) or square:sub(2,2)
end

function Piece:Draw()
	self:setPosition()
	love.graphics.draw(self:getImage(),self.x,self.y,0,self.scaleFactor,self.scaleFactor)
end

--steps, int, number of steps to check
-- return, string with position ('a2')
function Piece:moveForward(square)
	local square = (square == nil) and self.square or square
	local column = self:getColumn(square)
	local row = tonumber(self:getRow(square))

	if self.color == 'white' and row < 8 then
		row = row + 1
	elseif self.color == 'black' and row > 1 then
		row = row - 1
	else
		return nil
	end

	local resultSquare = column .. row

	return resultSquare
end

function Piece:moveLeft(square)
	local square = (square == nil) and self.square or square
	local columnIndex = array.index_of(Board.columns, self:getColumn(square))
	local row = self:getRow(square)

	if self.color == 'white' and columnIndex > 1 then
		columnIndex = columnIndex - 1
	elseif self.color == 'black' and columnIndex < 8 then
		columnIndex = columnIndex + 1
	else
		return nil
	end

	local column = Board.columns[columnIndex]
	local resultSquare = column .. row

	return resultSquare
end




function Piece:moveRight(square)
	local square = (square == nil) and self.square or square
	local columnIndex = array.index_of(Board.columns, self:getColumn(square))
	local row = self:getRow(square)

	if self.color == 'white' and columnIndex < 8 then
		columnIndex = columnIndex + 1
	elseif self.color == 'black' and columnIndex > 1 then
		columnIndex = columnIndex - 1
	else
		return nil
	end

	local column = Board.columns[columnIndex]

	local square = column .. row

	return square
end


function Piece:moveBackwards(square)
	local square = (square == nil) and self.square or square
	local column = self:getColumn(square)
	local row = tonumber(self:getRow(square))

	if self.color == 'white' and row >  1 then
		row = row - 1
	elseif self.color == 'black' and row < 8 then
		row = row + 1
	else
		return nil
	end

	local resultSquare = column .. row

	return resultSquare
end


function Piece:infiniteRightUpMoves(tempSquare)
	local moves = {}

	repeat
		tempSquare = self:moveRight(tempSquare)
		if tempSquare ~= nil then
			tempSquare = self:moveForward(tempSquare)
		else
			return moves
		end


		if chessBoard:pieceInSquare(tempSquare) ~= nil then
			if self:_isThisMoveAnAttack(tempSquare) == true then
				table.insert(moves, tempSquare)
			end

			break;
		end

		if tempSquare ~= nil then
			table.insert(moves, tempSquare)
		end
	until(tempSquare == nil)

	return moves
end


function Piece:infiniteLeftUpMoves(tempSquare)
	local moves = {}

	repeat
		tempSquare = self:moveLeft(tempSquare)
		if tempSquare ~= nil then
			tempSquare = self:moveForward(tempSquare)
		else
			return moves
		end

		if chessBoard:pieceInSquare(tempSquare) ~= nil then
			if self:_isThisMoveAnAttack(tempSquare) == true then
				table.insert(moves, tempSquare)
			end

			break;
		end

		if tempSquare ~= nil then
			table.insert(moves, tempSquare)
		end
	until(tempSquare == nil)

	return moves
end




function Piece:infiniteLeftBackwardsMoves(tempSquare)
	local moves = {}

	repeat

		tempSquare = self:moveLeft(tempSquare)
		if tempSquare ~= nil then
			tempSquare = self:moveBackwards(tempSquare)
		else
			return moves
		end


		if chessBoard:pieceInSquare(tempSquare) ~= nil then
			if self:_isThisMoveAnAttack(tempSquare) == true then
				table.insert(moves, tempSquare)
			end

			break;
		end

		if tempSquare ~= nil then
			table.insert(moves, tempSquare)
		end
	until(tempSquare == nil)

	return moves
end


function Piece:infiniteRightBackwardsMoves(tempSquare)
	local moves = {}

	repeat
		tempSquare = self:moveRight(tempSquare)
		if tempSquare ~= nil then
			tempSquare = self:moveBackwards(tempSquare)
		else
			return moves
		end


		if chessBoard:pieceInSquare(tempSquare) ~= nil then
			if self:_isThisMoveAnAttack(tempSquare) == true then
				table.insert(moves, tempSquare)
			end

			break;
		end

		if tempSquare ~= nil then
			table.insert(moves, tempSquare)
		end
	until(tempSquare == nil)

	return moves
end


function Piece:getImage()
	return love.graphics.newImage('images/'..self.type..'_'..(self.color):sub(1,1)..'.png')
end

function Piece:infiniteForwardMoves(tempSquare)
	local moves = {}

	repeat
		tempSquare = self:moveBackwards(tempSquare)

		if chessBoard:pieceInSquare(tempSquare) ~= nil then
			if self:_isThisMoveAnAttack(tempSquare) == true then
				table.insert(moves, tempSquare)
			end

			break;
		end

		if tempSquare ~= nil then
			table.insert(moves, tempSquare)
		end
	until(tempSquare == nil)

	return moves
end


function Piece:infiniteBackwardsMoves(tempSquare, limit)
	local moves = {}

	repeat
		tempSquare = self:moveForward(tempSquare)

		if chessBoard:pieceInSquare(tempSquare) ~= nil then
			if self:_isThisMoveAnAttack(tempSquare) == true then
				table.insert(moves, tempSquare)
			end

			break;
		end

		if tempSquare ~= nil then
			table.insert(moves, tempSquare)
		end
	until(tempSquare == nil)

	return moves
end

function Piece:infiniteRightMoves(tempSquare,limit)
	local moves = {}

	repeat
		tempSquare = self:moveRight(tempSquare)

		if chessBoard:pieceInSquare(tempSquare) ~= nil then
			if self:_isThisMoveAnAttack(tempSquare) == true then
				table.insert(moves,  tempSquare)
			end

			break;
		end

		if tempSquare ~= nil then
			table.insert(moves, tempSquare)
		end
	until(tempSquare == nil)

	return moves
end

function Piece:infiniteLeftMoves(tempSquare)
	local leftMoves = {}
	repeat
		tempSquare = self:moveLeft(tempSquare)

		if chessBoard:pieceInSquare(tempSquare) ~= nil then
			if self:_isThisMoveAnAttack(tempSquare) == true then
				table.insert(leftMoves, tempSquare)
			end

			break;
		end

		if tempSquare ~= nil then
			table.insert(leftMoves, tempSquare)
		end

	until(tempSquare == nil)

	return leftMoves
end



--square: Sting(ex. e4)
--return: boolean
function Piece:_isThisMoveAnAttack(square)
	local pieceIndex = chessBoard:pieceInSquare(square)
	local otherPiece = Pieces[pieceIndex]

	if otherPiece.color ~= self.color then
		return true
	else
		return false
	end
end


function Piece:moveTo(square)
	local possibleMoves = self:legalMoves()

	if array.index_of(possibleMoves, square) ~= -1 and self.color == chessBoard.hasTurn then
		chessBoard:killPieceInSquare(square)
		self.square = square
		self.hasMoved = true
		chessBoard:afterMove()
	end

	self.grabFactor = 0
	self.grabed = false
end


function Piece:getSquare()
	return self.square
end

function Piece:legalMoves()
	local possibleMoves = self:getPossibleMoves()


	for i = #possibleMoves, 1, -1 do
	    move = possibleMoves[i]
	    if bot:willItsKingBeCheckedAfterPieceMoves(self.id, move) == true then
			table.remove(possibleMoves, i)
		end
	end

	return possibleMoves
end

function Piece:getSymbol()
	return self.symbol
end

function Piece:getPosition()
	return self.square
end

return Piece
