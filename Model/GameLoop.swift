//
//  GameLoop.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

import Foundation

typealias MoveGetter = (Board, History, GameConfig) -> Move

class GameLoop {
    let config: GameConfig
    let rules: Rules
    let getMove: MoveGetter

    var history: History
    var board: Board
    
    init(config:GameConfig, rules: Rules, getMove:MoveGetter) {
        self.rules = rules
        self.config = config
        self.getMove = getMove
        
        self.history = History()
        self.board = Board.defaultBoard()
    }
    //TODO: init with history and/or board
    
    func run() {
        while true {
            var move = getMove(board, history, config)
            move.validateMove(board, history: history, rules: rules)
            if (move.isValid) {
                history.append(move)
                board = Board.applyMove(board, move: move)
                if (move.isCheckMate || move.isConceed){
                    print("Game Over.")
                    print("board: \(board)")
                    print("board: \(history)")
                    break
                }
            }
            else {
                print("Invalid move \(move). Violates rule \(move.violation)")
            }
        }
    }
}
