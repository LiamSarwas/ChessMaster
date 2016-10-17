//
//  Move.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

// In chess, all moves require only a start location to an end location.
// While castling involves two pieces/moves, the movement of the
// king unabmiguously determines the start and end location of the rook.
// Therefore, a castling move is specified by the movement of the king only.

// Obviously, not all possible moves are valid.
// The validity of a move is determined by the rules of chess (Rules.swift),
// given the board position at the time of the move.

typealias Move = (start:Location, end:Location)

func == (lhs: Move, rhs: Move) -> Bool {
    return (lhs.start == rhs.start) && (lhs.end == rhs.end)
}
