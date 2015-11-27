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
    private var _castlingOptions: CastlingOptions
    private var _enPassantTargetSquare: Location?
    private var _halfMoveClock: Int
    private var _fullMoveNumber: Int
    
    private var _lastCapturedPiece: Piece?
    private var _isActiveColorInCheck: Bool
    private var _activeColorHasMoves: Bool
    private var _winningColor: Color?
    private var _gameOver: Bool
    private var _isOfferOfDrawAvailable: Bool
    
    init (board: [Location: Piece],
          activeColor: Color,
          castlingOptions: CastlingOptions,
          enPassantTargetSquare: Location?,
          halfMoveClock: Int,
          fullMoveNumber: Int)
    {
        _board = board
        _activeColor = activeColor
        _castlingOptions = castlingOptions
        _enPassantTargetSquare = enPassantTargetSquare
        _halfMoveClock = halfMoveClock
        _fullMoveNumber = fullMoveNumber
        
        _isOfferOfDrawAvailable = false
        
        //Set the end of move variable to a best guess, so that self is fully initialized
        _gameOver = false
        _isActiveColorInCheck = false
        _activeColorHasMoves = true
        //Set the end of move variables
        endOfMoveChecks()
    }
    
    convenience init()
    {
        self.init(
            board: Rules.defaultStartingBoard,
            activeColor: Color.White,
            castlingOptions: CastlingOptions.All,
            enPassantTargetSquare: nil,
            halfMoveClock: 0,
            fullMoveNumber: 0)
    }

    func Clone() -> Game {
        return self
        //FIXME: Implement
    }
    
    //MARK: Getters
    
    var board: Board {
        get { return _board }
    }
    
    var activeColor: Color {
        get { return _activeColor }
    }
    
    var inActiveColor: Color {
        get { return _activeColor == .White ? .Black : .White }
    }
    
    var castlingOptions: CastlingOptions {
        get { return _castlingOptions }
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
    
    //MARK: Get Game Status
    
    var isActiveColorInCheck: Bool {
        get { return _isActiveColorInCheck }
    }
    
    var lastCapturedPiece: Piece? {
        get { return _lastCapturedPiece }
    }
    
    var isOfferOfDrawAvailable: Bool {
        get { return _isOfferOfDrawAvailable }
    }
    
    var isCheckMate: Bool {
        get { return _isActiveColorInCheck && !_activeColorHasMoves }
    }
    
    var isStaleMate: Bool {
        get { return !_isActiveColorInCheck && !_activeColorHasMoves }
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
    
    //MARK:  Moves
    
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
        if isOfferOfDrawAvailable {
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
            let movingPiece = board[move.start]!
            let newEnPassantTargetSquare = Rules.enPassantTargetSquare(board, move:move)
            let castelingRookMove = Rules.rookMoveWhileCastling(board, move: move)
            let promotionPiece = Rules.promotionPiece(board, move: move, promotionKind: promotionKind)
            let resetHalfMoveClock = Rules.resetHalfMoveClock(board, move: move)
            
            // Update State of Game
            _lastCapturedPiece = nil
            if let enPassantCaptureSquare = enPassantCaptureSquare(move) {
                _lastCapturedPiece = board[enPassantCaptureSquare]
                _board[enPassantCaptureSquare] = nil
            }
            if _lastCapturedPiece == nil {
                _lastCapturedPiece = board[move.end]
            }
            _board[move.end] = promotionPiece == nil ? movingPiece : promotionPiece
            _board[move.start] = nil
            if castelingRookMove != nil {
                _board[castelingRookMove!.end] = board[castelingRookMove!.start]!
                _board[castelingRookMove!.start] = nil
            }
            updateCastlingOptions(move.start)
            _enPassantTargetSquare = newEnPassantTargetSquare
            _activeColor = inActiveColor
            _isOfferOfDrawAvailable = false
            //FIXME:
            _halfMoveClock = resetHalfMoveClock ? 0 : halfMoveClock + 1
            _fullMoveNumber += (activeColor == .White ? 1 : 0)
            endOfMoveChecks()
            
            //FIXME: Save history
            
        } else {
            print("Illegal Move from \(move.start) to \(move.end)")
        }
    }
    
    func undoMove() {
        //Undoes the last move
        //FIXME: Implement
    }
    
    func redoMove() {
        //Restores the last undone move
        //FIXME: Implement
    }
    
    //MARK: Private methods
    
    func endOfMoveChecks() {
        _isActiveColorInCheck = Rules.isPlayerInCheck(board, kingsColor: activeColor)
        _activeColorHasMoves = Rules.doesActivePlayerHaveMoves(self)
        _winningColor = isCheckMate ? inActiveColor : nil
        _gameOver = !_activeColorHasMoves
    }
    
    func updateCastlingOptions(location:Location) {
        //Options decrease if king or rook moves
        if location == Location(rank:1, file:.E) {
            _castlingOptions.subtractInPlace(.BothWhite)
        }
        if location == Location(rank:1, file:.A) {
            _castlingOptions.subtractInPlace(.WhiteQueenSide)
        }
        if location == Location(rank:1, file:.H) {
            _castlingOptions.subtractInPlace(.WhiteKingSide)
        }
        if location == Location(rank:8, file:.E) {
            _castlingOptions.subtractInPlace(.BothBlack)
        }
        if location == Location(rank:8, file:.A) {
            _castlingOptions.subtractInPlace(.BlackQueenSide)
        }
        if location == Location(rank:8, file:.H) {
            _castlingOptions.subtractInPlace(.BlackKingSide)
        }
    }

    func enPassantCaptureSquare(move: Move) -> Location? {
        if let piece = board[move.start] {
            if piece.kind == .Pawn && move.end == enPassantTargetSquare {
                return Location(rank:move.start.rank, file:move.end.file)
            }
        }
        return nil
    }
}
