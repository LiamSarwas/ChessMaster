//
//  GameLoop.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

import Foundation

typealias MoveGetter = (Game, History, GameConfig) -> Move

class GameLoop {
    let config: GameConfig
    let rules: Rules
    let getMove: MoveGetter

    var history: History
    var game: Game
    
    init(config:GameConfig, rules: Rules, getMove:MoveGetter) {
        self.rules = rules
        self.config = config
        self.getMove = getMove
        
        self.history = History()
        self.game = Game.defaultGame()
    }
    //TODO: init with history and/or board
    
    func run() {
        while true {
            var move = getMove(game, history, config)
            move.validateMove(game, history: history, rules: rules)
            if (move.isValid) {
                history.append(move)
                game = Game.applyMove(game, move: move)
                if (move.isCheckMate || move.isConceed){
                    print("Game Over.")
                    print("game: \(game)")
                    print("history: \(history)")
                    break
                }
            }
            else {
                print("Invalid move \(move). Violates rule \(move.violation)")
            }
        }
    }
}
