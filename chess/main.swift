//
//  main.swift
//  chess
//
//  Created by Regan Sarwas on 11/15/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

import Foundation

if let game = "rnbqkbnr/pppppppp/8/4k3/8/8/PPPPPPPP/RNBQKBNR b k f6 3 1".fenGame {
    print("\(game)")
    for (location,piece) in game.board {
        print("\(piece) at \(location)")
    }
    print("Possible moves for e5")
    for possibleMove in game.validMoves(Location(rank: 5, file:.E)) {
        print("\(possibleMove)")
    }
} else {
    print("Not a valid FEN line")
}

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

