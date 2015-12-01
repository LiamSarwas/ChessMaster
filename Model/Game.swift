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
    private var _currentStateIndex: Int
    
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
        _currentStateIndex = 0

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

    //MARK: Getters
    
    var boardState: BoardState {
        return _currentStateIndex < _history.count ? _history[_currentStateIndex].board : _boardState
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

    var isOptionalDraw: Bool {
        return 50 <= halfMoveClock || 3 <= _history.filter({$0.board == _boardState}).count
    }

    var isMandatoryDraw: Bool {
        return 75 <= halfMoveClock || 5 <= _history.filter({$0.board == _boardState}).count
    }

    func validMoves(start:Location) -> [Location]
    {
        return Rules.validMoves(boardState, start:start)
    }
    
    //MARK:  Moves
    
    func resign()
    {
        _gameOver = true
        _winningColor = inActiveColor
    }
    
    func offerDraw()
    {
        if isGameOver {
            return
        }
        _isOfferOfDrawAvailable = true
    }
    
    func acceptDraw()
    {
        if isGameOver {
            return
        }
        if isOfferOfDrawAvailable {
            _gameOver = true
        }
    }
    
    func claimDraw()
    {
        if isGameOver {
            return
        }
        if isOptionalDraw {
            _gameOver = true
        }
    }
    
    func makeMove(move:Move, promotionKind:Kind = .Queen) -> ()
    {
        if isGameOver {
            return
        }
        if let (newBoardState,lastCapturedPiece) = Rules.makeMove(boardState, move: move) {

            //Happens if you backup several moves, and then start to replay
            //Since we can no longer redo moves, we need to trim the abandoned branch
            while _currentStateIndex < _history.count {
                _history.removeLast()
            }
            _history.append((board: _boardState, move: move))
            _currentStateIndex += 1
            _boardState = newBoardState
            _lastCapturedPiece = lastCapturedPiece

            endOfMoveChecks()
        } else {
            print("Illegal Move from \(move.start) to \(move.end)")
        }
    }
    
    func undoMove() {
        //Undoes the last move
        if 0 < _currentStateIndex {
            _currentStateIndex -= 1
        }
    }
    
    func redoMove() {
        //Restores the last undone move
        if _currentStateIndex < _history.count {
            _currentStateIndex += 1
        }
    }
    
    //MARK: Private methods
    
    func endOfMoveChecks() {
        _isOfferOfDrawAvailable = false
        _isActiveColorInCheck = Rules.isPlayerInCheck(board, kingsColor: activeColor)
        _activeColorHasMoves = Rules.doesActivePlayerHaveMoves(boardState)
        _winningColor = isCheckMate ? inActiveColor : nil
        _gameOver = !_activeColorHasMoves || isMandatoryDraw
    }
}

//MARK: CustomDebugStringConvertible, CustomStringConvertible

extension Game: CustomDebugStringConvertible, CustomStringConvertible {
    var description: String {
        return "\(boardState)"
    }

    var debugDescription: String {
        return description
    }
}

//MARK: String Extension

extension String {
    var fenGame: Game? {
        if let boardState = self.fenBoard {
            return Game(boardState: boardState)
        }
        return nil
    }
}