//
//  main.swift
//  chess
//
//  Created by Regan Sarwas on 11/15/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//


//CHECK FOR EDGE CASES IN MOVE GENERATION
//PARTICULARLY WHEN YOU START ON THE EDGE!!!
let bitBoard = BitBoard()

BitBoard.buildRookMoveDatabase()

let testBoard: UInt64 = 0b00000000000000000000000000000000000000000000000000000000000000000

print("\(testBoard.asBoard)")

//BitBoard.readRookMoves()
//BitBoard.makeMasks()

print("\(BitBoard.retrieveRookMove(testBoard, loc: 54).asBoard)")



/*
let perm = BitBoard.generateRookOccupancyPermutations(35)

print("\(perm[250].asBoard)")
print("\(BitBoard.generateRookMoves(perm[250], loc: 35).asBoard)")
*/

/*
for i in 0..<perm.count
{
    print("\(perm[i].asBoard)")
}
*/


/*
BitBoard.makeMasks()
for mask in BitBoard.rookMoveMasks
{
    print("\(mask.asBoard)")
}
*/



/*
print("\(BitBoard.LeftEdgeMask.asBoard)")
print("\(BitBoard.RightEdgeMask.asBoard)")
print("\(BitBoard.TopEdgeMask.asBoard)")
print("\(BitBoard.BottomEdgeMask.asBoard)")

print("\(bitBoard)")
*/






/*
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
    (myboardstate,_) = myboardstate.makeMove((Location("e2")!, Location("e4")!))!
    print("myboard: \(myboardstate)")
    print("game: \(game)")

} else {
    print("Not a valid FEN line")
}

print("Check make move")
if let game = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".fenGame {
    print("  Start: \(game)")
    var move = (Location("e2")!, Location("e4")!)
    print("   Move: \(move)")
    game.makeMove(move)
    print("   End1: \(game)")
    move = (Location("b8")!, Location("c6")!)
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
*/



