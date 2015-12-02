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
    private var _winningColor: Color?
    private var _gameOver: Bool
    private var _isOfferOfDrawAvailable: Bool
    
    init (boardState: BoardState)
    {
        _history = []
        _boardState = boardState
        _currentStateIndex = 0

        _isOfferOfDrawAvailable = false
        _gameOver = false

        //Set the end of move variable to a best guess, so that self is fully initialized before calling any methods
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

    var history: History {
        return _history
    }

    //MARK: Get Game Status
    
    var lastCapturedPiece: Piece? {
        return _lastCapturedPiece
    }
    
    var isOfferOfDrawAvailable: Bool {
        return _isOfferOfDrawAvailable
    }
    
    var isCheckMate: Bool {
        return boardState.isActiveColorInCheck && !boardState.activeColorHasMoves
    }
    
    var isStaleMate: Bool {
        return !boardState.isActiveColorInCheck && !boardState.activeColorHasMoves
    }
    
    var isGameOver: Bool {
        return _gameOver
    }
    
    var winningColor: Color? {
        return _winningColor
    }

    var isOptionalDraw: Bool {
        return 50 <= boardState.halfMoveClock || 3 <= history.filter({$0.board == boardState}).count
    }

    var isMandatoryDraw: Bool {
        return 75 <= boardState.halfMoveClock || 5 <= history.filter({$0.board == boardState}).count
    }

    //MARK:  Moves
    
    func resign()
    {
        _gameOver = true
        _winningColor = boardState.inActiveColor
    }
    
    func offerDraw()
    {
        if !isGameOver {
            _isOfferOfDrawAvailable = true
        }
    }
    
    func acceptDraw()
    {
        if !isGameOver && isOfferOfDrawAvailable {
            _gameOver = true
        }
    }
    
    func claimDraw()
    {
        if !isGameOver && isOptionalDraw {
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
        _winningColor = isCheckMate ? boardState.inActiveColor : nil
        _gameOver = !boardState.activeColorHasMoves || isMandatoryDraw
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