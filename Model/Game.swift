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
    
    // Mark - Status Updates
    
    func colorOfPieceAtLocation(location: Location) -> Color? {
        if let conflictPiece = board[location] {
            return conflictPiece.color
        }
        return nil
    }
    
    // Mark - Make Move
    
    func validMoves(start:Location) -> [Location]
    {
        return Rules.validMoves(self, start:start)
    }
    
    func makeMove(move:Move) -> ()
    {
        //FIXME: Check Promotion, and Check
        if validMoves(move.start).contains(move.end) {
            let piece = _board[move.start]!
            let newEnPassantTargetSquare = Rules.enPassantTargetSquare(self, move:move)
            if let enPassantCaptureSquare = enPassantCaptureSquare(move) {
                _board[enPassantCaptureSquare] = nil
            }
            let rookMove = Rules.rookMoveWhileCastling(self, move: move)
            _board[move.end] = piece
            _board[move.start] = nil
            if rookMove != nil {
                _board[rookMove!.end] = _board[rookMove!.start]!
                _board[rookMove!.start] = nil
            }
            _enPassantTargetSquare = newEnPassantTargetSquare
            _activeColor = _activeColor == Color.White ? .Black : .White
            updateCastlingOptions(move.start)
            //FIXME: Save history
            //FIXME: Update Counts
            //FIXME: Set flag if move puts opponent in check
            //FIXME: Check for checkmate
        } else {
            print("Illegal Move from \(move.start) to \(move.end)")
        }
    }

    func updateCastlingOptions(location:Location) {
        if location == Location(rank:1, file:.E) {
            _whiteHasKingSideCastleAvailable = false
            _whiteHasQueenSideCastleAvailable = false
        }
        if location == Location(rank:1, file:.A) {
            _whiteHasQueenSideCastleAvailable = false
        }
        if location == Location(rank:1, file:.H) {
            _whiteHasKingSideCastleAvailable = false
        }
        if location == Location(rank:8, file:.E) {
            _blackHasKingSideCastleAvailable = false
            _blackHasQueenSideCastleAvailable = false
        }
        if location == Location(rank:8, file:.A) {
            _blackHasQueenSideCastleAvailable = false
        }
        if location == Location(rank:8, file:.H) {
            _blackHasKingSideCastleAvailable = false
        }
    }

    func enPassantCaptureSquare(move: Move) -> Location? {
        if let piece = _board[move.start] {
            if piece.kind == .Pawn && move.end == _enPassantTargetSquare {
                return Location(rank:move.start.rank, file:move.end.file)
            }
        }
        return nil
    }
    
}
