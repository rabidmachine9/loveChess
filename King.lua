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


	self.possibleMoves = array.filter(self.possibleMoves, function(square)
			return array.index_of(bot.attackedSquares, square) == -1
		end
	)

	for i=#(self.possibleMoves),1,-1  do
		local square = self.possibleMoves[i]
		local pieceIndex = chessBoard:pieceInSquare(square)

		if pieceIndex ~= nil then
			local otherPiece = Pieces[pieceIndex]
			if otherPiece.color ==  self.color then
				table.remove(self.possibleMoves, i)
			else
				self.possibleMoves[i] = self.possibleMoves[i]
			end
		end
	end



	if self.hasMoved == false then
		self.possibleMoves = array.concat(self:castleCheck(), self.possibleMoves)
	end




	return self.possibleMoves
end

function King:castleCheck()
	local kingRook
	local queenRook
	local castels = {}

	if self.color == 'white' then
		kingRook = Pieces[chessBoard:pieceInSquare('h1')]
		queenRook = Pieces[chessBoard:pieceInSquare('a1')]

		if kingRook ~= nil and kingRook.hasMoved == false and chessBoard:areSquaresEmpty({'f1', 'g1'}) then
			table.insert(castels, 'g1')
		end

		if queenRook ~= nil and queenRook.hasMoved == false and chessBoard:areSquaresEmpty({'b1', 'c1', 'd1'}) then
			table.insert(castels, 'c1')
		end
	else
		kingRook = Pieces[chessBoard:pieceInSquare('h8')]
		queenRook = Pieces[chessBoard:pieceInSquare('a8')]

		if kingRook ~= nil and kingRook.hasMoved == false and chessBoard:areSquaresEmpty({'f8', 'g8'}) then
			table.insert(castels, 'g8')
		end

		if queenRook ~= nil and queenRook.hasMoved == false and chessBoard:areSquaresEmpty({'b8', 'c8', 'd8'}) then
			table.insert(castels, 'c8')
		end
	end

	return castels

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

	local kingRook = Pieces[chessBoard:pieceInSquare(rookSquare)]
	kingRook.square = 'f' .. self:getRow()

end

function King:queenSideCastle(square)
	self.square = square
	local rookSquare = 'a'.. self:getRow()

	local queenRook = Pieces[chessBoard:pieceInSquare(rookSquare)]
	queenRook.square = 'd' .. self:getRow()

end



return King
