//
//  Game.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

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
    
    private var _lastCapturedPiece: Piece?
    private var _activeColorInCheck: Bool
    private var _activeColorHasMoves: Bool
    private var _winningColor: Color?
    private var _gameOver: Bool
    private var _isOfferOfDrawAvailable: Bool
    
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
        
        _isOfferOfDrawAvailable = false
        
        //Set the end of move variable to a best guess, so that self is fully initialized
        _gameOver = false
        _activeColorInCheck = false
        _activeColorHasMoves = true
        //Set the end of move variables
        endOfMoveChecks()
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
    
    var inActiveColor: Color {
        get { return _activeColor == .White ? .Black : .White }
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
    
    // Mark - Get Game Status
    
    func colorOfPieceAtLocation(location: Location) -> Color? {
        if let conflictPiece = board[location] {
            return conflictPiece.color
        }
        return nil
    }
    
    var activeColorInCheck: Bool {
        get { return _activeColorInCheck }
    }
    
    var lastCapturedPiece: Piece? {
        get { return _lastCapturedPiece }
    }
    
    var isOfferOfDrawAvailable: Bool {
        get { return _isOfferOfDrawAvailable }
    }
    
    var isCheckMate: Bool {
        get { return _activeColorInCheck && !_activeColorHasMoves }
    }
    
    var isStaleMate: Bool {
        get { return !_activeColorInCheck && !_activeColorHasMoves }
    }
    
    var isGameOver: Bool {
        get { return _gameOver }
    }
    
    var winningColor: Color? {
        get { return _winningColor }
    }
    
    func validMoves(start:Location) -> [Location]
    {
        return Rules.validMoves(self, start:start)
    }
    
    // Mark - Moves
    
    func resign()
    {
        _gameOver = true
        _winningColor = inActiveColor
    }
    
    func offerDraw()
    {
        _isOfferOfDrawAvailable = true
    }
    
    func acceptDraw()
    {
        if _isOfferOfDrawAvailable {
            _gameOver = true
        }
    }
    
    func claimDraw()
    {
        //Check rules for draw 9.2 & 9.3, and set _gameOver as appropriate
        //FIXME: Implement
    }
    
    func makeMove(move:Move, promotionKind:Kind = .Queen) -> ()
    {
        if isGameOver {
            return
        }
        if validMoves(move.start).contains(move.end) {
            // Save some state at beginning of move
            let movingPiece = _board[move.start]!
            let newEnPassantTargetSquare = Rules.enPassantTargetSquare(board, move:move)
            let castelingRookMove = Rules.rookMoveWhileCastling(board, move: move)
            let promotionPiece = Rules.promotionPiece(board, move: move, promotionKind: promotionKind)
            
            // Update State of Game
            _lastCapturedPiece = nil
            if let enPassantCaptureSquare = enPassantCaptureSquare(move) {
                _lastCapturedPiece = _board[enPassantCaptureSquare]
                _board[enPassantCaptureSquare] = nil
            }
            if _lastCapturedPiece == nil {
                _lastCapturedPiece = _board[move.end]
            }
            _board[move.end] = promotionPiece == nil ? movingPiece : promotionPiece
            _board[move.start] = nil
            if castelingRookMove != nil {
                _board[castelingRookMove!.end] = _board[castelingRookMove!.start]!
                _board[castelingRookMove!.start] = nil
            }
            updateCastlingOptions(move.start)
            _enPassantTargetSquare = newEnPassantTargetSquare
            _activeColor = inActiveColor
            _isOfferOfDrawAvailable = false
            _halfMoveClock += 1
            _fullMoveNumber += (_activeColor == .Black ? 1 : 0)
            endOfMoveChecks()
            
            //FIXME: Save history
            
        } else {
            print("Illegal Move from \(move.start) to \(move.end)")
        }
    }
    
    func endOfMoveChecks() {
        _activeColorInCheck = Rules.isPlayerInCheck(board, kingsColor: _activeColor)
        _activeColorHasMoves = Rules.doesActivePlayerHaveMoves(self)
        _winningColor = isCheckMate ? inActiveColor : nil
        _gameOver = !_activeColorHasMoves
    }
    func updateCastlingOptions(location:Location) {
        //Options decrease if king or rook moves
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
