//
//  Game_moves.swift
//  Chess_cmd
//
//  Created by Regan Sarwas on 11/5/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

extension Game {
    func validMoves(start:Location) -> [Location]
    {
        return Rules.validMoves(self, start:start)
    }
    
    func makeMove(start: Location, end:Location) -> Game
    {
        return self
    }
    
    static func applyMove(game:Game, move:Move) -> Game {
        //Assumes the move is valid for Game
        
        return game
    }

}
