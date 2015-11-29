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

extension BoardState : Equatable {}

func == (lhs:BoardState, rhs:BoardState) -> Bool {
    return lhs.board == rhs.board &&
        lhs.activeColor == rhs.activeColor &&
        lhs.castlingOptions == rhs.castlingOptions &&
        lhs.enPassantTargetSquare == rhs.enPassantTargetSquare
    //Move counts are not used in equality; because we only care Rules 9.2 and 9.3
}
