//
//  BoardState.swift
//  ChessMaster
//
//  Created by Regan Sarwas on 11/27/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

struct BoardState {
    let board: Board
    let activeColor: Color
    let castlingOptions: CastlingOptions
    let enPassantTargetSquare: Location?
    let halfMoveClock: Int
    let fullMoveNumber: Int
}
