//
//  Board_moves.swift
//  Chess_cmd
//
//  Created by Regan Sarwas on 11/5/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

extension Board {
    func validMoves(start:Location) -> [Location]
    {
        if let piece = self.board[start]
        {
            if piece.color == self.activeColor {
                
            } else {
                print("You can't move an opponents piece")
                return []
            }
        }
        print("No piece at \(start)")
        return []
    }
    
    func makeMove(start: Location, end:Location) -> Board
    {
        return self
    }
    
    static func applyMove(board:Board, move:Move) -> Board {
        //Assumes the move is valid for board
        
        return board
    }

}
