//
//  Game.swift
//  ChessMaster
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

class Game {
    fileprivate var _board: Board
    fileprivate var _history = History()
    
    fileprivate var _lastCapturedPiece: Piece?
    fileprivate var _isOfferOfDrawAvailable = false
    fileprivate var _playerResigned = false
    fileprivate var _isDraw = false

    // MARK: - Initializers

    init (board: Board)
    {
        _board = board
    }

    convenience init() {
        self.init(board: Board())
    }

    convenience init?(fromFEN fen: String) {
        if let board = Board(fromFEN: fen) {
            self.init(board: board)
        } else {
            return nil
        }
    }

    // TODO: Create game from History or PGN
    // We need to copy the history because it is a class, and we do not want the
    // provider to change it on us.
    // We will need to set _board and _lastCapturedPiece by applying the last move to the last board

    // MARK: - Game Status Properties

    var board: Board {
        if let historicalBoard = _history.board {
            return historicalBoard
        }
        return _board
    }

    // Since History is a class that retains state
    // we do not want anyone else to have a pointer to it
    // providing a copy may be fine.

    var lastCapturedPiece: Piece? {
        return _lastCapturedPiece
    }
    
    var isOfferOfDrawAvailable: Bool {
        return _isOfferOfDrawAvailable
    }
    
    var isCheckMate: Bool {
        return board.isActiveColorInCheck && !board.activeColorHasMoves
    }
    
    var isStaleMate: Bool {
        return !board.isActiveColorInCheck && !board.activeColorHasMoves
    }
    
    var playerResigned: Bool {
        return _playerResigned
    }

    var isDraw: Bool {
        return _isDraw || isMandatoryDraw
    }

    var isGameOver: Bool {
        return _playerResigned || isDraw || !board.activeColorHasMoves
    }

    var winningColor: Color? {
        return (isCheckMate || playerResigned) ? board.inActiveColor : nil
    }

    var isOptionalDraw: Bool {
        return 50 <= board.halfMoveClock || 3 <= _history.occurrencesOfBoard(board)
    }

    var isMandatoryDraw: Bool {
        return 75 <= board.halfMoveClock || 5 <= _history.occurrencesOfBoard(board)
    }

    // MARK: - Move Methods
    
    func resign()
    {
        if isGameOver { return }
        _playerResigned = true
    }
    
    func offerDraw()
    {
        if isGameOver { return }
        _isOfferOfDrawAvailable = true
    }
    
    func acceptDraw()
    {
        if isGameOver { return }
        if isOfferOfDrawAvailable {
            _isDraw = true
        }
    }
    
    func claimDraw()
    {
        if isGameOver { return }
        if isOptionalDraw {
            _isDraw = true
        }
    }
    
    func makeMove(_ move: Move, promotionKind: Kind = .queen) -> ()
    {
        if isGameOver { return }
        if let (newBoard, lastCapturedPiece) = board.makeMove(move) {
            // Making a valid move implicitly rejects an offer for a draw
            _isOfferOfDrawAvailable = false
            _history.appendMove(move, board: board)
            _board = newBoard
            _lastCapturedPiece = lastCapturedPiece
        } else {
            print("Illegal Move from \(move.start) to \(move.end) for \(board)")
        }
    }
    
    func undoMove() {
        _history.backup()
    }
    
    func redoMove() {
        _history.forward()
    }
}

// MARK: - CustomDebugStringConvertible, CustomStringConvertible

// TODO: Add some game state to this output

extension Game: CustomDebugStringConvertible, CustomStringConvertible {
    var description: String {
        return "\(board)"
    }

    var debugDescription: String {
        return description
    }
}
