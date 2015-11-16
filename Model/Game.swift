//
//  Game.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

import Foundation

struct Game {
    var board: [Location: Piece]
    var activeColor: Color
    let whiteHasKingSideCastleAvailable: Bool
    let whiteHasQueenSideCastleAvailable: Bool
    let blackHasKingSideCastleAvailable: Bool
    let blackHasQueenSideCastleAvailable: Bool
    let enPassantTargetSquare: Location?
    let halfMoveClock: Int
    let fullMoveNumber: Int
    
    static func defaultGame() -> Game {
        let defaultBoard = [
            Location(rank:1, file:.A): Piece(color:.White, kind:.Rook),
            Location(rank:1, file:.B): Piece(color:.White, kind:.Knight),
            Location(rank:1, file:.C): Piece(color:.White, kind:.Bishop),
            Location(rank:1, file:.D): Piece(color:.White, kind:.Queen),
            Location(rank:1, file:.E): Piece(color:.White, kind:.King),
            Location(rank:1, file:.F): Piece(color:.White, kind:.Bishop),
            Location(rank:1, file:.G): Piece(color:.White, kind:.Knight),
            Location(rank:1, file:.H): Piece(color:.White, kind:.Rook),
            
            Location(rank:2, file:.A): Piece(color:.White, kind:.Pawn),
            Location(rank:2, file:.B): Piece(color:.White, kind:.Pawn),
            Location(rank:2, file:.C): Piece(color:.White, kind:.Pawn),
            Location(rank:2, file:.D): Piece(color:.White, kind:.Pawn),
            Location(rank:2, file:.E): Piece(color:.White, kind:.Pawn),
            Location(rank:2, file:.F): Piece(color:.White, kind:.Pawn),
            Location(rank:2, file:.G): Piece(color:.White, kind:.Pawn),
            Location(rank:2, file:.H): Piece(color:.White, kind:.Pawn),
            
            Location(rank:7, file:.A): Piece(color:.Black, kind:.Pawn),
            Location(rank:7, file:.B): Piece(color:.Black, kind:.Pawn),
            Location(rank:7, file:.C): Piece(color:.Black, kind:.Pawn),
            Location(rank:7, file:.D): Piece(color:.Black, kind:.Pawn),
            Location(rank:7, file:.E): Piece(color:.Black, kind:.Pawn),
            Location(rank:7, file:.F): Piece(color:.Black, kind:.Pawn),
            Location(rank:7, file:.G): Piece(color:.Black, kind:.Pawn),
            Location(rank:7, file:.H): Piece(color:.Black, kind:.Pawn),
            
            Location(rank:8, file:.A): Piece(color:.Black, kind:.Rook),
            Location(rank:8, file:.B): Piece(color:.Black, kind:.Knight),
            Location(rank:8, file:.C): Piece(color:.Black, kind:.Bishop),
            Location(rank:8, file:.D): Piece(color:.Black, kind:.Queen),
            Location(rank:8, file:.E): Piece(color:.Black, kind:.King),
            Location(rank:8, file:.F): Piece(color:.Black, kind:.Bishop),
            Location(rank:8, file:.G): Piece(color:.Black, kind:.Knight),
            Location(rank:8, file:.H): Piece(color:.Black, kind:.Rook),
        ]
        return Game(board: defaultBoard,
            activeColor: .White,
            whiteHasKingSideCastleAvailable: true,
            whiteHasQueenSideCastleAvailable: true,
            blackHasKingSideCastleAvailable: true,
            blackHasQueenSideCastleAvailable: true,
            enPassantTargetSquare: nil,
            halfMoveClock: 0,
            fullMoveNumber: 0)
    }
}
