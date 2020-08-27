local cute = require("cute")
local shapes = require("src.shapes")


notion("Single pawn", function()
  local paw = Pawn:new('white','b2')
  check(paw:getPossibleMoves()).shallowMatches({'b3', 'b4'})
end)

notion("Single rook", function()
  local tow = Tower:new('white','a1')
  local moves = tow:getPossibleMoves()
  local result = {'a2', 'a3', 'a4','a5','a6','a7','a8','b1','c1','d1','e1','f1','g1','h1'}
  table.sort(moves)
  table.sort(result)
  check(moves).shallowMatches(result)
end)


notion("King", function()
  local king = King:new('white','e1')
  local moves = king:getPossibleMoves()
  local result = {'e2','d1','f1','d2','f2'}
  table.sort(moves)
  table.sort(result)
  check(moves).shallowMatches(result)
end)


notion("Horse ", function()
  local horse = Knight:new('white','g1')
  local moves = horse:getPossibleMoves()
  local result = {'e2','h3','f3',}
  table.sort(moves)
  table.sort(result)
  check(moves).shallowMatches(result)
end)

notion("Bishop", function()
  local bis = Bishop:new('white', 'c1')
  local moves = bis:getPossibleMoves()
  local result = {'a3','b2','d2','e3','f4','g5','h6'}
  table.sort(moves)
  table.sort(result)
  check(moves).shallowMatches(result)
end)

notion("Queen", function()
  local queen = Queen:new('white', 'd1')
  local moves = queen:getPossibleMoves()
  local result = {'a1','b1','c1','e1','f1','g1','h1','d2','d3','d4','d5','d6','d7','d8','e2','f3','g4','h5','c2','b3','a4'}
  table.sort(moves)
  table.sort(result)
  check(moves).shallowMatches(result)
end)

notion("Stalemate1", function()
  chessBoard = Board:new('black')
  local pos = chessBoard:setupPosition(Positions.stalemate1)
  chessBoard.castlingRights = '';
  local moves = chessBoard:getAllMoves()
  local result = {}
  check(moves).shallowMatches(result)
end)
