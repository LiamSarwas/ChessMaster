//
//  main.swift
//  chess
//
//  Created by Regan Sarwas on 11/15/15.
//  Copyright © 2015 Regan Sarwas. Alocation rights reserved.
//

print("Check modifying board does not change game")
let fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
if let game = Game(fromFEN: fen) {
    print("  game: \(game)")

    //print("Check pieces at location")
    //for (location,piece) in game.board {
    //    print("\(piece) at \(location)")
    //}
    
    //print("Possible moves for e5")
    //for possibleMove in game.validMoves(e5) {
    //    print("\(possibleMove)")
    //}
    
    //game.board[a1] = nil  //compiler error: board is a get-only property
    var myboardstate = game.board
    (myboardstate,_) = myboardstate.makeMove((e2,e4))!
    print("  my board: \(myboardstate)")
    print("  game board: \(game.board)")

} else {
    print("  Board setup '\(fen)' is not a valid FEN line")
}

print("Check making moves")
if let game = Game(fromFEN: fen) {
    print("  Start: \(game.board)")
    var move = (e2,e4)
    print("  Move: \(move)")
    game.makeMove(move)
    print("  End1: \(game.board)")
    move = (b8,c6)
    print("  Move: \(move)")
    game.makeMove(move)
    print("  End2: \(game.board)")
} else {
    print("  Board setup '\(fen)' is not a valid FEN line")
}


print("Check locations in directions")
let startLocation = c5
print("  North from \(startLocation)")
for location in startLocation.toNorth {
    print("    \(location)")
}
print("  South from \(startLocation)")
for location in startLocation.toSouth {
    print("    \(location)")
}
print("  East from \(startLocation)")
for location in startLocation.toEast {
    print("    \(location)")
}
print("  West from \(startLocation)")
for location in startLocation.toWest {
    print("    \(location)")
}
print("  Northeast from \(startLocation)")
for location in startLocation.toNortheast {
    print("    \(location)")
}
print("  Northwest from \(startLocation)")
for location in startLocation.toNorthwest {
    print("    \(location)")
}
print("  Southeast from \(startLocation)")
for location in startLocation.toSoutheast {
    print("    \(location)")
}
print("  Southwest from \(startLocation)")
for location in startLocation.toSouthwest {
    print("    \(location)")
}
