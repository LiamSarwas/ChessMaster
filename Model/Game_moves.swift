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
    
    mutating func makeMove(start: Location, end:Location) -> ()
    {
        //FIXME: Check castling, enPassant, Promotion, and Check
        if validMoves(start).contains(end) {
            board[end] = board[start]!
            activeColor = activeColor == Color.White ? .Black : .White
        } else {
            print("Illegal Move from \(start) to \(end)")
        }
    }
    
    static func applyMove(game:Game, move:Move) -> Game {
        //Assumes the move is valid for Game
        
        return game
    }

}
