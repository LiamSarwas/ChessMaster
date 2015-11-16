//
//  main.swift
//  chess
//
//  Created by Regan Sarwas on 11/15/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

import Foundation

if let game = "rnbqkbnr/ppp2ppp/8/4r3/2p2q2/8/PPPPPPPP/RNBQKBNR b k f6 3 1".fenGame {
    print("\(game)")
    for (location,piece) in game.board {
        print("\(piece) at \(location)")
    }
} else {
    print("Not a valid FEN line")
}



