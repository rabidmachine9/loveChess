require 'Tower'
require 'Pawn'
require 'Queen'
require 'King'
require 'Knight'
require 'Bishop'

PieceFactory = {}
PieceFactory.pieces = {}

--position: object
--return nothing
function PieceFactory:spawnPosition(position)
	local pieces = {}
	for i,piecePosition in pairs(position.white) do
		p = self:createPiece('white',piecePosition)
		if p ~= nil then
			p.id = #self.pieces + 1
			table.insert(self.pieces, p)

		end
	end

	for i,piecePosition in pairs(position.black) do
		p = self:createPiece('black',piecePosition)
		if p ~= nil then
			p.id = #self.pieces + 1
			table.insert(self.pieces, p)
		end
	end

	return self.pieces
end

function PieceFactory:createPiece(color,position)
	if string.len(position) == 2 then
		return Pawn:new(color,position)
	elseif (position):sub(1,1) == 'r' then
		return Tower:new(color,position:sub(2,3))
	elseif (position):sub(1,1) == 'k' then
		return King:new(color,position:sub(2,3))
	elseif (position):sub(1,1) == 'n' then
		return Knight:new(color,position:sub(2,3))
	elseif (position):sub(1,1) == 'q' then
		return Queen:new(color,position:sub(2,3))
	elseif (position):sub(1,1) == 'b' then
		return Bishop:new(color,position:sub(2,3))
	else
		print('Error: the position you are entering cannot be interpreted!')
		return nil
	end

	return nil
end






return PieceFactory
