//
//  Move.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

import Foundation

struct Move: Equatable {
    let start: Location
    let end: Location
    let piece: Piece
    var notouch: String
    
    // TODO: moves only make sense in the context of a board state, so add board state to move
    // TODO: piece can be derived from the start location on the board
    
    var isValidated = false
    var isValid = false
    var isCheck = false
    var isCheckMate = false
    var violation: String
    var isCapture = false
    
    // To castle, move the king, and the rook will follow.
    var isCastle: Bool {
        get {
            return isKingSideCastle || isQueenSideCastle
        }
    }
    var isKingSideCastle: Bool {
        get {
            if piece.kind != .King {
                return false
            }
            let whiteKingSide = start == Location(rank:1, file:.E) && end == Location(rank:1, file:.G)
            let blackKingSide = start == Location(rank:8, file:.E) && end == Location(rank:8, file:.G)
            return whiteKingSide || blackKingSide
        }
    }
    var isQueenSideCastle: Bool {
        get {
            if piece.kind != .King {
                return false
            }
            let whiteQueenSide = start == Location(rank:1, file:.E) && end == Location(rank:1, file:.B)
            let blackQueenSide = start == Location(rank:8, file:.E) && end == Location(rank:8, file:.B)
            return whiteQueenSide || blackQueenSide
        }
    }
   
    // To conceed a player moves tips over his king (i.e the end location = the start location)
    var isConceed: Bool {
        get {
            return piece.kind == .King && start == end
        }
    }

    mutating func validateMove(game: Game, history: History, rules: Rules) {
        self.isValidated = true
    }
}

// MARK: Hashable

extension Move: Hashable {
    var hashValue: Int {
        return start.hashValue ^ end.hashValue ^ piece.hashValue
    }
}

// MARK: Equatable

func == (left:Move, right:Move) -> Bool {
    return (left.start == right.start) && (left.end == right.end) && (left.piece == right.piece)
}

// MARK: CustomStringConvertible

extension Move: CustomStringConvertible {
    var description: String {
        get {
            if (isKingSideCastle) {
                return "O-O"
            }
            if (isQueenSideCastle) {
                return "O-O-O"
            }
            let capture = isCapture ? "x" : ""
            //FIXME remove ambiguity with file or rank or both in that order
            //FIXME add promotions and check/checkmate
            return "\(piece)\(capture)\(end)"
        }
    }
}
