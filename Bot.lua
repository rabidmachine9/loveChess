local array = require 'lib.array'
local inspect = require 'lib.inspect'


Bot = {}

Bot.attackedSquares = {}

function Bot:new()
	local b = {}

	self.__index = self

	return setmetatable(b, self)
end



function Bot:afterMove()

end


function Bot:findAttackedSquares()
	self.attackedSquares = {}

	for i,p in ipairs(Pieces) do
		if p.color ~= chessBoard.hasTurn and p.tempDead == false then
			if p.type ~= 'pawn' then
				local moves = p:getPossibleMoves()
				self.attackedSquares = array.concat(self.attackedSquares, moves)
			elseif p.type == 'pawn' then
				local attacks = p:getControlledSquares()
				self.attackedSquares = array.concat(self.attackedSquares, attacks)
			end
		end
	end

	return array.uniq(self.attackedSquares)
end



function Bot:undieAll()
	for i,p in ipairs(Pieces) do
		p.tempDead = false
	end
end

function Bot:willItsKingBeCheckedAfterPieceMoves(piece_id, potential_square)
	pieceInSquareIndex = chessBoard:pieceInSquare(potential_square)
	local result = false

	if pieceInSquareIndex ~= nil then
		Pieces[pieceInSquareIndex].tempDead = true
	end



	local original_square = Pieces[piece_id].square

	--changing one of the most important global objects temporarily
	Pieces[piece_id].square = potential_square

	self.attackedSquares = {}

	local hisMajesty = {}
	for i,p in ipairs(Pieces) do
		if p.color == chessBoard.hasTurn and p.type == 'king' then
			hisMajesty = p
		end
	end

	local attackedSquares = self:findAttackedSquares()


	if array.index_of(attackedSquares, hisMajesty.square) ~= -1 then
		result =  true
	end

	Pieces[piece_id].square = original_square
	self:undieAll()

	return result

end

function Bot:evaluatePosition(pieces, board)
	local evaluation = 0

	if board.hasTurn == 'white' then
		evaluation = evaluation + 0.3
	else
		evaluation = evaluation - 0.3
	end


	for i,p in ipairs(pieces) do
		local column = p.column
		if p.color == 'white' then
			evaluation = evaluation + p.points
			if p.type == 'pawn' and column > 4 then
				evaluation = evaluation + (column - 4) * 0.1
			end
		else
			evaluation = evaluation - p.points
			if p.type == 'pawn' and column < 5 then
				evaluation = evaluation + (column - 5) * 0.1
			end
		end




	end

	return evaluation
end
