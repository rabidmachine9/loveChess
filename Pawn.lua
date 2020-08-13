require 'Piece'
local array = require 'lib.array'
local inspect = require 'lib.inspect'


Pawn = Piece:new()

Pawn.hasMoved = false
Pawn.type = 'pawn'
Pawn.amPasanOffence = false -- allows other pawns to amPasan attack
Pawn.amPassanDefence = false
Pawn.forwardMove = nil
Pawn.points = 1
Pawn.justDidDoubleMove = false
Pawn.moveMeta = {}


function Pawn:getPossibleMoves()
	self.possibleMoves = {}

	self.forwardMove = self:moveForward()

	if chessBoard:isSquareEmpty(self.forwardMove) then 
		table.insert(self.possibleMoves, self.forwardMove)
		self.moveMeta[self.forwardMove] = 'single'

		if self.hasMoved == false then 
			local doubleMove = self:moveForward(self.forwardMove)
			if chessBoard:isSquareEmpty(doubleMove) then
				table.insert(self.possibleMoves, doubleMove)
				self.moveMeta[doubleMove] = 'double'
			end
		end
	end

	return array.concat(self.possibleMoves, self:getAttacks())
end

function Pawn:getAttacks()
	local attackSquares = {}
	
	local leftAttack = self:moveLeft(self.forwardMove)
	local rightAttack = self:moveRight(self.forwardMove)

	table.insert(attackSquares, rightAttack)
	table.insert(attackSquares, leftAttack)

	attackSquares = array.filter(attackSquares, function(square)
			local pieceInSquareIndex = chessBoard:pieceInSquare(square)
			return (chessBoard:isSquareEmpty(square) == false and Pieces[pieceInSquareIndex].color ~= self.color)
		end
	)

	for i,s in ipairs(attackSquares) do
		self.moveMeta[s] = 'attack'
	end

	if self:inFifthRow() then 
		local leftSquare = self:moveLeft()
		local rightSquare = self:moveRight()
		print('ok')
		if self:canAmPassan(leftSquare) then 
			table.insert(attackSquares, leftAttack)
			self.moveMeta[leftAttack] = 'am'
		elseif self:canAmPassan(rightSquare) then
			table.insert(attackSquares, rightAttack)
			self.moveMeta[rightAttack] = 'am'
	
		end
	end

	return attackSquares

end


function Pawn:canAmPassan(square)
	local pieceIndex = chessBoard:pieceInSquare(square)

	if pieceIndex ~= nil  and Pieces[pieceIndex].color ~= self.color  and Pieces[pieceIndex].justDidDoubleMove == true then	 
		return true	
	end

	return false
end


function Pawn:inFifthRow()
	if self.color == 'white' then
		print("white")
		if tonumber(self:getRow()) == 5 then
			return true
		end
	elseif self.color == 'black' then
		if tonumber(self:getRow()) == 4 then
			return true
		end
	else
		return false
	end
end


function Pawn:getControlledSquares()
	local controlledSquares = {}
	
	local leftAttack = self:moveLeft(forwardMove)
	local rightAttack = self:moveRight(forwardMove)

	table.insert(controlledSquares, rightAttack)
	table.insert(controlledSquares, leftAttack)

	return controlledSquares
end


function Pawn:moveTo(square)
	local possibleMoves = self:legalMoves()

	if array.index_of(possibleMoves, square) ~= -1 and self.color == chessBoard.hasTurn then
		if  self.moveMeta[square]  == 'attack' then 
			chessBoard:killPieceInSquare(square)
		elseif self.moveMeta[square]  == 'am' then 
			local attackedRow =  self.color == 'white' and 5 or 4
			local attackedSquare = self:getColumn(square) .. attackedRow
			chessBoard:killPieceInSquare(attackedSquare)
		elseif self.moveMeta[square] == 'double' then 
			self.justDidDoubleMove = true
		end



		self.square = square
		if self:inRome() then
			print("Rome is conquered!")
			love.graphics.setBlendMode("alpha", "premultiplied")
    		love.graphics.draw(canvas)
    		love.graphics.draw(canvas, 100, 0)
		end

		self.hasMoved = true
		chessBoard:afterMove()
	end 


	self.grabFactor = 0
	self.grabed = false	
end


function Pawn:inRome()
	if self:getRow() == '8' and self.color == 'white' then
		return true
	elseif self:getRow() == '1' and self.color == 'black' then 
		return true
	else
		return false
	end
end


return Pawn