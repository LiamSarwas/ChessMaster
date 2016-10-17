//
//  main.swift
//  chess
//
//  Created by Regan Sarwas on 11/15/15.
//  Copyright © 2015 Regan Sarwas. Alocation rights reserved.
//

let movetext = "1. e4 e5 2. Nf3 Nc6 3. Bb5 a6 4. Ba4 Nf6 5. O-O Be7 6. Re1 b5 7. Bb3 d6 8. c3\n" +
"O-O 9. h3 Nb8 10. d4 Nbd7 11. c4 c6 12. cxb5 axb5 13. Nc3 Bb7 14. Bg5 b4 15.\n" +
"Nb1 h6 16. Bh4 c5 17. dxe5 Nxe4 18. Bxe7 Qxe7 19. exd6 Qf6 20. Nbd2 Nxd6 21.\n" +
"Nc4 Nxc4 22. Bxc4 Nb6 23. Ne5 Rae8 24. Bxf7+ Rxf7 25. Nxf7 Rxe1+ 26. Qxe1 Kxf7\n" +
"27. Qe3 Qg5 28. Qxg5 hxg5 29. b3 Ke6 30. a3 Kd6 31. axb4 cxb4 32. Ra5 Nd5 33.\n" +
"f3 Bc8 34. Kf2 Bf5 35. Ra7 g6 36. Ra6+ Kc5 37. Ke1 Nf4 38. g3 Nxh3 39. Kd2 Kb5\n" +
"40. Rd6 Kc5 41. Ra6 Nf2 42. g4 Bd3 43. Re6 1/2-1/2"

if let history = try PGNDeserializer.parseMoveText(movetext) {
    print(history)
} else {
    print("parser error")
}



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
