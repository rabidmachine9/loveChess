require 'Piece'
local array = require 'lib.array'
local inspect = require 'lib.inspect'
King = Piece:new()



King.hasMoved = false
King.type = 'king'
King.symbol = 'k'
King.isChecked = false
King.points = 0


function King:getPossibleMoves()
	self.possibleMoves = {}
	print("King Moves 1:"..inspect(self.possibleMoves))
	local forward =  self:moveForward()
	table.insert(self.possibleMoves, forward)
	table.insert(self.possibleMoves, self:moveLeft())
	table.insert(self.possibleMoves, self:moveRight())
	local backwards = self:moveBackwards()
	table.insert(self.possibleMoves, backwards)

	table.insert(self.possibleMoves, self:moveRight(forward))
	table.insert(self.possibleMoves, self:moveRight(backwards))
	table.insert(self.possibleMoves, self:moveLeft(forward))
	table.insert(self.possibleMoves, self:moveLeft(backwards))
	print("King Moves 2:"..inspect(self.possibleMoves))

	if self.color == chessBoard.hasTurn then
		self.possibleMoves = array.filter(self.possibleMoves, function(square)
				return array.index_of(bot:findAttackedSquares(), square) == -1
			end
		)
	end
	
	print("King Moves 3:"..inspect(self.possibleMoves))
	for i=#(self.possibleMoves),1,-1  do
		local square = self.possibleMoves[i]
		local pieceIndex = chessBoard:pieceInSquare(square)

		if pieceIndex ~= nil then
			local otherPiece = chessBoard.pieces[pieceIndex]
			if otherPiece.color ==  self.color then
				table.remove(self.possibleMoves, i)
			else
				self.possibleMoves[i] = self.possibleMoves[i]
			end
		end
	end
	print("King Moves 4:"..inspect(self.possibleMoves))


	if self.hasMoved == false and string.len(chessBoard:getCastlingRights(self.color)) > 0  then
		self.possibleMoves = array.concat(self:castleCheck(), self.possibleMoves)
	end
	print("King Moves 5:"..inspect(self.possibleMoves))

	self.possibleMoves = array.uniq(self.possibleMoves)
	print("King Moves 6:"..inspect(self.possibleMoves))
	return self.possibleMoves
end

function King:castleCheck()
	local kingRook
	local queenRook
	local castels = {}

	if self.color == 'white' then
		kingRook = chessBoard.pieces[chessBoard:pieceInSquare('h1')]
		queenRook = chessBoard.pieces[chessBoard:pieceInSquare('a1')]

		if kingRook ~= nil and kingRook.hasMoved == false and chessBoard:areSquaresEmpty({'f1', 'g1'}) then
			table.insert(castels, 'g1')
		end

		if queenRook ~= nil and queenRook.hasMoved == false and chessBoard:areSquaresEmpty({'b1', 'c1', 'd1'}) then
			table.insert(castels, 'c1')
		end
	else
		kingRook = chessBoard.pieces[chessBoard:pieceInSquare('h8')]
		queenRook = chessBoard.pieces[chessBoard:pieceInSquare('a8')]

		if kingRook ~= nil and kingRook.hasMoved == false and chessBoard:areSquaresEmpty({'f8', 'g8'}) then
			table.insert(castels, 'g8')
		end

		if queenRook ~= nil and queenRook.hasMoved == false and chessBoard:areSquaresEmpty({'b8', 'c8', 'd8'}) then
			table.insert(castels, 'c8')
		end
	end

	return castels

end

function King:initialSquare()
	local initialSquare
	if self.color == 'white' then
		initialSquare = 'e1'
	else
		initialSquare = 'e8'
	end

	return initialSquare
end

function King.isKingChecked()
	if array.index_of(bot.attackedSquares, self.square) == -1  then
		self.isChecked = false
	else
		self.isChecked = true
	end
end

function King:moveTo(square)
	local possibleMoves = self:legalMoves()

	if array.index_of(possibleMoves, square) ~= -1 and self.color == chessBoard.hasTurn then
		if  square == 'g'.. (self:getRow()) and self.hasMoved == false  then
			print('castling kingside')
			self:kingSideCastle(square)
		elseif square == 'c'.. (self:getRow()) and self.hasMoved == false  then
			print('castling queenside')
			self:queenSideCastle(square)
		else
			chessBoard:killPieceInSquare(square)
			self.square = square
		end

		self.hasMoved = true
		chessBoard:afterMove()
	end


	self.grabFactor = 0
	self.grabed = false


end

function King:kingSideCastle(square)
	self.square = square
	local rookSquare = 'h'.. self:getRow()

	local kingRook = chessBoard.pieces[chessBoard:pieceInSquare(rookSquare)]
	kingRook.square = 'f' .. self:getRow()

end

function King:queenSideCastle(square)
	self.square = square
	local rookSquare = 'a'.. self:getRow()

	local queenRook = chessBoard.pieces[chessBoard:pieceInSquare(rookSquare)]
	queenRook.square = 'd' .. self:getRow()

end



return King
