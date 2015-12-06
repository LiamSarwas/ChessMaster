//
//  Game.swift
//  ChessMaster
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

class Game {
    private var _board: Board
    private var _history: History = []
    private var _currentStateIndex = 0 //The length of the array (one more than the stack)
    
    private var _lastCapturedPiece: Piece?
    private var _isOfferOfDrawAvailable = false
    private var _gameOver = false
    private var _winningColor: Color?

    init (board: Board)
    {
        _board = board
        CheckForGameOver()
    }

    convenience init() {
        self.init(board: Board())
    }

    //MARK: Getters
    
    var board: Board {
        return _currentStateIndex < _history.count ? _history[_currentStateIndex].board : _board
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
        return board.isActiveColorInCheck && !board.activeColorHasMoves
    }
    
    var isStaleMate: Bool {
        return !board.isActiveColorInCheck && !board.activeColorHasMoves
    }
    
    var isGameOver: Bool {
        return _gameOver
    }
    
    var winningColor: Color? {
        return _winningColor
    }

    var isOptionalDraw: Bool {
        return 50 <= board.halfMoveClock || 3 <= history.filter({$0.board == board}).count
    }

    var isMandatoryDraw: Bool {
        return 75 <= board.halfMoveClock || 5 <= history.filter({$0.board == board}).count
    }

    //MARK:  Moves
    
    func resign()
    {
        _gameOver = true
        _winningColor = board.inActiveColor
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
        if !isGameOver {
            if let (newBoard,lastCapturedPiece) = board.makeMove(move) {
                // Making a valid move implicitly rejects an offer for a draw
                _isOfferOfDrawAvailable = false

                //If we make a valid move after 'undo's without matching 'redo's, we need to
                //erase the abandoned state on the history stack
                while _currentStateIndex < _history.count {
                    (_board,_) = _history.removeLast()
                }
                _history.append((board: board, move: move))
                _currentStateIndex += 1
                _board = newBoard
                _lastCapturedPiece = lastCapturedPiece
                CheckForGameOver()
            } else {
                print("Illegal Move from \(move.start) to \(move.end) for \(board)")
            }
        }
    }
    
    func undoMove() {
        //Undoes the last move
        if 0 < _currentStateIndex {
            _currentStateIndex -= 1
            //TODO: I think there is a bug here
            if isGameOver {
                CheckForGameOver() // Will undo the game over state
            }
        }
    }
    
    func redoMove() {
        //Restores the last undone move
        if _currentStateIndex < _history.count {
            _currentStateIndex += 1
            CheckForGameOver()
        }
    }
    
    //MARK: Private methods
    
    func CheckForGameOver() {
        _winningColor = isCheckMate ? board.inActiveColor : nil
        _gameOver = !board.activeColorHasMoves || isMandatoryDraw
    }
}

//MARK: CustomDebugStringConvertible, CustomStringConvertible

extension Game: CustomDebugStringConvertible, CustomStringConvertible {
    var description: String {
        return "\(board)"
    }

    var debugDescription: String {
        return description
    }
}

//MARK: String Extension

extension String {
    var fenGame: Game? {
        if let board = self.fenBoard {
            return Game(board: board)
        }
        return nil
    }
}