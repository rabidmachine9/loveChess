Positions = {}

Positions.empty = {
	white = {},
	black = {}
 }

Positions.initial = {
	white  = { "a2","b2","c2","d2","e2","f2","g2","h2","ra1","rh1","ke1","bc1","bf1","qd1", "nb1", "ng1"},
	black =  { "a7","b7","c7","d7","e7","f7","g7","h7","ra8","rh8","ke8","bc8","bf8","qd8", "nb8", "ng8"}
}



Positions.castleCheck = {
	white  = { "a2","b2","c2","d2","e2","f2","g2","h2","ra1","nb1","rh1","ke1"},
	black =  { "a7","b7","c7","d7","e7","f7","g7","h7","ra8","rh8","ke8" }
}



Positions.amPassan = {
	white  = { "a2","b2","c2","d2","e2","f2","g2","h2","ra1","rh1","ke1"},
	black =  { "a7","b7","c7","d7","e4","f7","g7","h7","ra8","rh8","ke8" }
}


Positions.singlePawn = {
	white = {"b2"},
	black = {}
}


return Positions
