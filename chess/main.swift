//
//  main.swift
//  chess
//
//  Created by Regan Sarwas on 11/15/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

if let game = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".fenGame {
    print("game: \(game)")
    
    //print("Check pieces at location")
    //for (location,piece) in game.board {
    //    print("\(piece) at \(location)")
    //}
    
    //print("Possible moves for e5")
    //for possibleMove in game.validMoves(Location(rank: 5, file:.E)) {
    //    print("\(possibleMove)")
    //}
    
    print("Check modifying board does not change game")
    //game.board[Location(rank:1, file:.A)] = nil  //compiler error: board is a get-only property
    var myboardstate = game.board
    (myboardstate,_) = myboardstate.makeMove((Location(rank:2, file:.E),Location(rank:4, file:.E)))!
    print("myboard: \(myboardstate)")
    print("game: \(game)")

} else {
    print("Not a valid FEN line")
}

print("Check make move")
if let game = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".fenGame {
    print("  Start: \(game)")
    var move = (Location(rank: 2, file: .E), Location(rank: 4, file: .E))
    print("   Move: \(move)")
    game.makeMove(move)
    print("   End1: \(game)")
    move = (Location(rank: 8, file: .B), Location(rank: 6, file: .C))
    print("   Move: \(move)")
    game.makeMove(move)
    print("   End2: \(game)")
} else {
    print("  Fail - initial board is invalid")
}

/*
let l = Location(rank:5, file:.E)
print("North from \(l)")
for ll in l.toNorth {
    print("   \(ll)")
}
print("South from \(l)")
for ll in l.toSouth {
    print("   \(ll)")
}
print("East from \(l)")
for ll in l.toEast {
    print("   \(ll)")
}
print("West from \(l)")
for ll in l.toWest {
    print("   \(ll)")
}
print("Northeast from \(l)")
for ll in l.toNortheast {
    print("   \(ll)")
}
print("Northwest from \(l)")
for ll in l.toNorthwest {
    print("   \(ll)")
}
print("Southeast from \(l)")
for ll in l.toSoutheast {
    print("   \(ll)")
}
print("Southwest from \(l)")
for ll in l.toSouthwest {
    print("   \(ll)")
}
*/




