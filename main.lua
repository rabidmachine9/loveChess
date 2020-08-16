require 'Board'
require 'Bot'
require 'Positions'
require 'PieceFactory'

local array = require 'lib.array'
local inspect = require 'lib.inspect'


local hasTurn = 'white'


clickedPieceIndex = nil

Pieces = {}
Pieces = PieceFactory:spawnPosition(Positions.initial)
chessBoard = Board:new(Pieces, 'white')


bot = Bot:new()

function love.load()

	canvas = love.graphics.newCanvas(800, 600)

    -- Rectangle is drawn to the canvas with the regular alpha blend mode.
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(1, 0, 0, 0.5)
    love.graphics.rectangle('fill', 0, 0, 100, 100)
    love.graphics.setCanvas()


	love.window.setMode(800, 800)
	background = love.graphics.newImage("images/chess-board.png")

end


function love.update()
		for i,p in ipairs(Pieces) do
			if p.type == 'pawn' and p.color == chessBoard.hasTurn then
				p.justDidDoubleMove = false
			end
		end
		hasTurn = chessBoard.hasTurn
end


function love.draw()

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(background)

	for i,piece in ipairs(Pieces) do
		piece:Draw()
	end

	love.graphics.setColor(255, 255, 255, 100)
	love.graphics.rectangle("fill",chessBoard.shadowSquareX, chessBoard.shadowSquareY, 100,100)

end


function love.mousepressed(x,y)
	print("-----------------------------------------------------------------------------------")

	square = chessBoard:getSquare(x,y)
	chessBoard:positionShadowSquare(square)
	clickedPieceIndex = chessBoard:pieceInSquare(square)

	print("Square: " .. square)


	if clickedPieceIndex ~= nil then
		clickedPiece = Pieces[clickedPieceIndex]
		clickedPiece.grabed = true

		print("Possible moves " .. assert(inspect(clickedPiece:getPossibleMoves())))
		print("Piece Id:" .. clickedPiece.id)
		print("Has Moved:" .. tostring(clickedPiece.hasMoved))
		print("Type:" .. clickedPiece.type)
		print("Color:" .. clickedPiece.color)
		print("Has turn:" .. chessBoard.hasTurn)
		print("Just Did double:" .. tostring(clickedPiece.justDidDoubleMove))
		print("Position:" .. assert(inspect(chessBoard:getPosition())))
		if clickedPiece.type == "pawn" then
			print("Reached in Rome:" .. tostring(clickedPiece:inRome()))
		end
	end
end

function love.mousereleased(x,y)
	local releaseSquare = chessBoard:getSquare(x,y)

	if clickedPieceIndex ~= nil then
		clickedPiece:moveTo(releaseSquare)
		bot:findAttackedSquares()
	end
	clickedPieceIndex = nil
	clickedPiece = nil
	chessBoard:hideShadowSquare()
end



function love.keypressed(key)
   if key == "v" or key == "V" then
      print("evaluation :" ..  bot:evaluatePosition(Pieces))
   end
end
