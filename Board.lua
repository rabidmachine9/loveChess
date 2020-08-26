local inspect = require 'lib.inspect'
local array = require 'lib.array'

Board = {}
Board.__index = Board


Board.columns = {'a' , 'b' ,'c' ,'d' ,'e' ,'f' ,'g' , 'h'}
Board.rows = {'8','7','6','5','4','3','2','1'}
Board.squareWidth = 100
Board.squareHeight = 100
Board.move = 1
Board.hasTurn = 'white'
Board.castlingRights = 'qkQK' --blackQueenSide,blackKingSide,whiteQueen,whiteKing

--constructor
function Board:new(pieces, hasTurn)
	local newBoard = {}

	newBoard.hasTurn = hasTurn
	newBoard.occupiedSquares = {}
	newBoard.shadowSquareX = 9999
	newBoard.shadowSquareY = 9999

	self.__index = self
	setmetatable(newBoard, self)

	return newBoard
end

function Board:getCastlingRights(color)
	local rights = ''
	for i = 1, #self.castlingRights do
		local c = str:sub(i,i)
		if color == 'white' and (c == 'q' or c == 'Q')  then
			rights = rights..c
		elseif color == 'black' and (c == 'k' or c == 'q') then
			rights = rights..c
		end
	end

	return rights

end

--moves a shadow effect square over the clicked square
function Board:positionShadowSquare(square)
	local pos = self:getSquareXY(square)
	Board.shadowSquareX = pos.x
	Board.shadowSquareY = pos.y
end

--hides shadow square
function Board:hideShadowSquare()
	Board.shadowSquareX = 9999
	Board.shadowSquareY = 9999
end

--x: position in pixels
--y:position in pixes
--return String square (ex. a2)
function Board:getSquare(x,y)
	local column = Board:findColumnFromX(x)
	local row = Board:findRowFromY(y)
	local square = column .. row
	return square

end

--args, x: int(pixel)
--return column: string
function Board:findColumnFromX(x)
	for i,column in ipairs(Board.columns) do
		if x < (i*100) then
			return column
		end
	end
end


--args, y: int(pixel)
--return column: string
function Board:findRowFromY(y)
	for i,row in ipairs(Board.rows) do
		if y < (i*100) then
			return row
		end
	end
end


--square: String (ex. 'b2')
--return Object the position of the the square in pixels {100,100}
function Board:getSquareXY(square)
	local pos = {}

	pos.x = (array.index_of(self.columns, (square):sub(1,1)) - 1) * self.squareWidth
	pos.y = (array.index_of(self.rows , (square):sub(2,2)) - 1) *  self.squareHeight

	return pos
end


--get id of a piece in a suare if none return nil
--args, square: string , Pieces: object
--return, number(index of Piece)
function Board:pieceInSquare(square)
	for i,p in ipairs(Pieces) do
		if p.square == square then
			return i
		end
	end

	return nil
end


function Board:colorOfPieceInSquare(square)
	for i,p in ipairs(Pieces) do
		if p.square == square then
			return p.color
		end
	end

	return 'none'
end

--args: square: string('a4')
--return: boolean
function Board:isSquareEmpty(square)
	for i,p in ipairs(Pieces) do
		if p.square == square then
			return false
		end
	end

	return true
end

-- check if a group of squares are ALL empty
-- args: squares: table with strings {'a1' ,'a2' ...  }
-- return: boolean
function Board:areSquaresEmpty(squares)
	for i,square in ipairs(squares) do
		if self:isSquareEmpty(square) == false then
			return false
		end
	end

	return true
end

--changes the color that has turn to play (Board.hasTurn)
function Board:afterMove()
	if self.hasTurn == 'white' then
		self.hasTurn = 'black'
	elseif self.hasTurn == 'black' then
		self.hasTurn = 'white'
		self.move = self.move + 1
	end

end



function Board:killPieceInSquare(square)

	for i,piece in ipairs(Pieces) do
		if piece.square == square then
			table.remove(Pieces,i)
			Board:reindexPieces()

			return true
		end
	end


	return false
end

function Board:reindexPieces()
	for i,p in ipairs(Pieces) do
		p.id = i
	end
end

function Board:getAllMoves()
	local moves = {}
	for i,p in ipairs(Pieces) do
		if p.color == self.hasTurn then
			local pieceSquare = p.symbol..p.square
			local pieceMoves = p:getPossibleMoves()
			for j,m in ipairs(pieceMoves) do
				local move = pieceSquare..m
				table.insert(moves,move)
			end
		end
	end
	print("these are the moves:".. inspect(moves))
	return moves
end

-- square: string
-- return, an object with the colors of all attackers
function Board:isSquareUnderAttack(square)
	local attackers = {}
	for i,p in ipairs(Pieces) do
		if p.type ~= 'pawn' then
			local moves = p:getPossibleMoves()
			if array.index_of(moves, square) ~= -1 then
				table.insert(attackers, p.color)
			end
		elseif p.type == 'pawn' then

			local attacks = p:getControlledSquares()
			if array.index_of(attacks, square) ~= -1 then

				table.insert(attackers, p.color)
			end
		end
	end
	return attackers
end


function Board:getPosition()
	local position = {}
	local ssq

	for i,p in ipairs(Pieces) do
		if p.color == 'white' then
			ssq = string.upper(p:getSymbol()) .. p:getSquare()
			table.insert(position,ssq)
		elseif p.color == 'black' then
			ssq = p:getSymbol() .. p:getSquare()
			table.insert(position,ssq)
		end
	end
	--table.sort(position)
	return position
end


function Board:getPositionHashTable()
	local position = {}
	local ssq

	for i,p in ipairs(Pieces) do
		if p.color == 'white' then
			position[p:getSquare()] = string.upper(p:getSymbol())
		elseif p.color == 'black' then
			position[p:getSquare()] = p:getSymbol()
		end
	end
	--table.sort(position)
	return position
end


function Board:posToFen()
	local positionTable = self:getPositionHashTable()
	local letters = 'abcdefgh'
	local FEN = ""
	local blanks = 0

	for col=8,1,-1  do
		if blanks ~= 0 then
			FEN = FEN..blanks..'/'
		elseif col ~= 8 then
			FEN = FEN..'/'
		end
		blanks = 0


		for i = 1, #letters do
			local row = letters:sub(i,i)
			local sq = row .. tostring(col)
			print(sq)
			if positionTable[sq] ~= nil then
				if blanks ~= 0 then
					FEN = FEN..blanks..positionTable[sq]
					blanks = 0
				else
					FEN = FEN..positionTable[sq]
				end
			else
				blanks = blanks+1
			end
		end
	end

	return FEN
end



return Board
