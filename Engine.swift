//
//  Engine.swift
//  ChessMaster
//
//  Created by Liam Sarwas on 11/17/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

import Foundation

struct Engine
{
    static let KnightTable =
    [-50,-40,-30,-30,-30,-30,-40,-50,
    -40,-20,  0,  0,  0,  0,-20,-40,
    -30,  0, 10, 15, 15, 10,  0,-30,
    -30,  5, 15, 20, 20, 15,  5,-30,
    -30,  0, 15, 20, 20, 15,  0,-30,
    -30,  5, 10, 15, 15, 10,  5,-30,
    -40,-20,  0,  5,  5,  0,-20,-40,
    -50,-40,-30,-30,-30,-30,-40,-50,]
    
    
    func search()
    {
        
    }
    
    static func evaluateBoard(game: Game) -> [Int]
    {
        var boardValues = [0, 0]
        var whiteBoardValue = 0
        var blackBoardValue = 0
        
        for (location, piece) in game.board
        {
            if piece.color == .White
            {
                if piece.kind == .King
                {
                   //Do I want to count the King's material value?
                }
                if piece.kind == .Queen
                {
                    whiteBoardValue += 900
                }
                if piece.kind == .Bishop
                {
                    whiteBoardValue += 300
                }
                if piece.kind == .Knight
                {
                    whiteBoardValue += 300
                    whiteBoardValue += KnightTable[convertToArrayIndex(location)]
                }
                if piece.kind == .Rook
                {
                    whiteBoardValue += 500
                }
                if piece.kind == .Pawn
                {
                    whiteBoardValue += 100
                }
            }
            if piece.color == .Black
            {
                if piece.kind == .King
                {
                    //Do I want to count the King's material value?
                }
                if piece.kind == .Queen
                {
                    blackBoardValue += 900
                }
                if piece.kind == .Bishop
                {
                    blackBoardValue += 300
                }
                if piece.kind == .Knight
                {
                    blackBoardValue += 300
                    blackBoardValue += KnightTable[convertToArrayIndex(location)]
                }
                if piece.kind == .Rook
                {
                    blackBoardValue += 500
                }
                if piece.kind == .Pawn
                {
                    blackBoardValue += 100
                }
            }
        }
        
        boardValues[0] = whiteBoardValue
        boardValues[1] = blackBoardValue
        
        return boardValues
    }
    
    static func convertToArrayIndex(loc: Location) -> Int
    {
        var y = 0
        var x = 0
        
        if loc.rank.value == 1
        {
            y += 56
        }
        if loc.rank.value == 2
        {
            y += 48
        }
        if loc.rank.value == 3
        {
            y += 40
        }
        if loc.rank.value == 4
        {
            y += 32
        }
        if loc.rank.value == 5
        {
            y += 24
        }
        if loc.rank.value == 6
        {
            y += 16
        }
        if loc.rank.value == 7
        {
            y += 8
        }
        if loc.rank.value == 8
        {
            y += 0
        }
        
        
        if loc.file == .A
        {
            x += 0
        }
        if loc.file == .B
        {
            x += 1
        }
        if loc.file == .C
        {
            x += 2
        }
        if loc.file == .D
        {
            x += 3
        }
        if loc.file == .E
        {
            x += 4
        }
        if loc.file == .F
        {
            x += 5
        }
        if loc.file == .G
        {
            x += 6
        }
        if loc.file == .H
        {
            x += 7
        }
        
        return y + x
    }
    
}