//
//  Game.swift
//  ChessMaster
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

class Game {
    private var _history: History
    private var _boardState: BoardState
    private var _currentState: Int
    
    private var _lastCapturedPiece: Piece?
    private var _isActiveColorInCheck: Bool
    private var _activeColorHasMoves: Bool
    private var _winningColor: Color?
    private var _gameOver: Bool
    private var _isOfferOfDrawAvailable: Bool
    
    init (boardState: BoardState)
    {
        _history = []
        _boardState = boardState
        _currentState = 0

        _isOfferOfDrawAvailable = false
        
        //Set the end of move variable to a best guess, so that self is fully initialized before calling any methods
        _gameOver = false
        _isActiveColorInCheck = false
        _activeColorHasMoves = true
        //Set the end of move variables to the real values
        endOfMoveChecks()
    }

    convenience init() {
        self.init(boardState: Rules.defaultStartingBoardState)
    }

    func Clone() -> Game {
        return self
        //FIXME: Implement
    }

    //MARK: Getters
    
    var boardState: BoardState {
        return _currentState < _history.count ? _history[_currentState].board : _boardState
    }

    var board: Board {
        get { return boardState.board }
    }

    var activeColor: Color {
        get { return boardState.activeColor }
    }
    
    var inActiveColor: Color {
        get { return boardState.activeColor == .White ? .Black : .White }
    }
    
    var castlingOptions: CastlingOptions {
        get { return boardState.castlingOptions }
    }

    var enPassantTargetSquare: Location? {
        get { return boardState.enPassantTargetSquare }
    }
    
    var halfMoveClock: Int {
        get { return boardState.halfMoveClock }
    }
    
    var fullMoveNumber: Int {
        get { return boardState.fullMoveNumber }
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
        if _history.filter({$0.board == _boardState}).count >= 3 {
            _gameOver = true
        }
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
            var newBoard = board
            _lastCapturedPiece = nil
            if let enPassantCaptureSquare = enPassantCaptureSquare(move) {
                _lastCapturedPiece = board[enPassantCaptureSquare]
                newBoard[enPassantCaptureSquare] = nil
            }
            if _lastCapturedPiece == nil {
                _lastCapturedPiece = board[move.end]
            }
            newBoard[move.end] = promotionPiece == nil ? movingPiece : promotionPiece
            newBoard[move.start] = nil
            if castelingRookMove != nil {
                newBoard[castelingRookMove!.end] = board[castelingRookMove!.start]!
                newBoard[castelingRookMove!.start] = nil
            }

            let newBoardState = BoardState(
                board: newBoard,
                activeColor: inActiveColor,
                castlingOptions: newCastlingOptions(move.start),
                enPassantTargetSquare: newEnPassantTargetSquare,
                halfMoveClock: resetHalfMoveClock ? 0 : halfMoveClock + 1,
                fullMoveNumber: fullMoveNumber + (activeColor == .White ? 1 : 0)
            )

            //Happens if you backup several moves, and then start to replay
            //Since we can no longer redo moves, we need to trim the abandoned branch
            while _currentState < _history.count {
                _history.removeLast()
            }
            _history.append((board: _boardState, move: move))
            _currentState += 1
            _boardState = newBoardState

            _isOfferOfDrawAvailable = false
            endOfMoveChecks()

        } else {
            print("Illegal Move from \(move.start) to \(move.end)")
        }
    }
    
    func undoMove() {
        //Undoes the last move
        if 0 < _currentState {
            _currentState += 1
        }

        _currentState -= 1
    }
    
    func redoMove() {
        //Restores the last undone move
        if _currentState < _history.count {
            _currentState += 1
        }
    }
    
    //MARK: Private methods
    
    func endOfMoveChecks() {
        _isActiveColorInCheck = Rules.isPlayerInCheck(board, kingsColor: activeColor)
        _activeColorHasMoves = Rules.doesActivePlayerHaveMoves(self)
        _winningColor = isCheckMate ? inActiveColor : nil
        _gameOver = !_activeColorHasMoves || mandatoryDraw()
    }
    
    func newCastlingOptions(location:Location) -> CastlingOptions {
        var newCastlingOptions = castlingOptions
        //Options decrease if king or rook moves
        if location == Location(rank:1, file:.E) {
            newCastlingOptions.subtractInPlace(.BothWhite)
        }
        if location == Location(rank:1, file:.A) {
            newCastlingOptions.subtractInPlace(.WhiteQueenSide)
        }
        if location == Location(rank:1, file:.H) {
            newCastlingOptions.subtractInPlace(.WhiteKingSide)
        }
        if location == Location(rank:8, file:.E) {
            newCastlingOptions.subtractInPlace(.BothBlack)
        }
        if location == Location(rank:8, file:.A) {
            newCastlingOptions.subtractInPlace(.BlackQueenSide)
        }
        if location == Location(rank:8, file:.H) {
            newCastlingOptions.subtractInPlace(.BlackKingSide)
        }
        return newCastlingOptions
    }

    func enPassantCaptureSquare(move: Move) -> Location? {
        if let piece = board[move.start] {
            if piece.kind == .Pawn && move.end == enPassantTargetSquare {
                return Location(rank:move.start.rank, file:move.end.file)
            }
        }
        return nil
    }

    func mandatoryDraw() -> Bool {
        return halfMoveClock == 75 || _history.filter({$0.board == _boardState}).count == 5
    }
}
