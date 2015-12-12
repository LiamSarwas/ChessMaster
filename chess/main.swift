//
//  main.swift
//  chess
//
//  Created by Regan Sarwas on 11/15/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

//let tests = ["a b c - d", "4k2r/R7/8/8/8/8/8/4R3 b k - 0 1", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"]
//for test in tests {
//    print("\(test)")
//    for part in test.split(" ") {
//        print("\(part)")
//    }
//}

print("Check modifying board does not change game")
//let fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
let fen = "4k2r/R7/8/8/8/8/8/4R3 b k - 0 1"
if let game = Game(fromFEN: fen) {
    print("game: \(game)")

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
    print("my board: \(myboardstate)")
    print("game board: \(game.board)")

} else {
    print("   Board setup '\(fen)' is not a valid FEN line")
}

print("Check making moves")
if let game = Game(fromFEN: fen) {
    print("  Start: \(game.board)")
    var move = (e2,e4)
    print("   Move: \(move)")
    game.makeMove(move)
    print("   End1: \(game.board)")
    move = (b8,c6)
    print("   Move: \(move)")
    game.makeMove(move)
    print("   End2: \(game.board)")
} else {
    print("   Board setup '\(fen)' is not a valid FEN line")
}

/*
let l = c5
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




