//
//  Game.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

import Foundation

typealias Board = [Location: Piece]

class Game {
    private var _board: Board
    private var _activeColor: Color
    private var _whiteHasKingSideCastleAvailable: Bool
    private var _whiteHasQueenSideCastleAvailable: Bool
    private var _blackHasKingSideCastleAvailable: Bool
    private var _blackHasQueenSideCastleAvailable: Bool
    private var _enPassantTargetSquare: Location?
    private var _halfMoveClock: Int
    private var _fullMoveNumber: Int
    
    init (board: [Location: Piece],
          activeColor: Color,
          whiteHasKingSideCastleAvailable: Bool,
          whiteHasQueenSideCastleAvailable: Bool,
          blackHasKingSideCastleAvailable: Bool,
          blackHasQueenSideCastleAvailable: Bool,
          enPassantTargetSquare: Location?,
          halfMoveClock: Int,
          fullMoveNumber: Int)
    {
            _board = board
            _activeColor = activeColor
            _whiteHasKingSideCastleAvailable = whiteHasKingSideCastleAvailable
            _whiteHasQueenSideCastleAvailable = whiteHasQueenSideCastleAvailable
            _blackHasKingSideCastleAvailable = blackHasKingSideCastleAvailable
            _blackHasQueenSideCastleAvailable = blackHasQueenSideCastleAvailable
            _enPassantTargetSquare = enPassantTargetSquare
            _halfMoveClock = halfMoveClock
            _fullMoveNumber = fullMoveNumber
    }
    
    convenience init()
    {
        self.init(
            board: Rules.defaultStartingBoard,
            activeColor: Color.White,
            whiteHasKingSideCastleAvailable: true,
            whiteHasQueenSideCastleAvailable: true,
            blackHasKingSideCastleAvailable: true,
            blackHasQueenSideCastleAvailable: true,
            enPassantTargetSquare: nil,
            halfMoveClock: 0,
            fullMoveNumber: 0)
    }
    
// Mark - Getters
    
    var board: Board {
        get { return _board }
    }
    
    var activeColor: Color {
        get { return _activeColor }
    }
    
    var whiteHasKingSideCastleAvailable: Bool {
        get { return _whiteHasKingSideCastleAvailable }
    }
    
    var whiteHasQueenSideCastleAvailable: Bool {
        get { return _whiteHasQueenSideCastleAvailable }
    }
    
    var blackHasKingSideCastleAvailable: Bool {
        get { return _blackHasKingSideCastleAvailable }
    }
    
    var blackHasQueenSideCastleAvailable: Bool {
        get { return _blackHasQueenSideCastleAvailable }
    }
    
    var enPassantTargetSquare: Location? {
        get { return _enPassantTargetSquare }
    }
    
    var halfMoveClock: Int {
        get { return _halfMoveClock }
    }
    
    var fullMoveNumber: Int {
        get { return _fullMoveNumber }
    }
    
    // Mark - Make Move
    
    func validMoves(start:Location) -> [Location]
    {
        return Rules.validMoves(self, start:start)
    }
    
    func makeMove(start: Location, end:Location) -> ()
    {
        //FIXME: Check castling, enPassant, Promotion, and Check
        if validMoves(start).contains(end) {
            _board[end] = _board[start]!
            _board[start] = nil
            _activeColor = _activeColor == Color.White ? .Black : .White
        } else {
            print("Illegal Move from \(start) to \(end)")
        }
    }
}
