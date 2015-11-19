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
    static let depth = 2
    static var score = 0
    static var bestMove : (Location, Location) = ("a1".fenLocation!, "a1".fenLocation!)
    
   
    static func getMove(game: Game) -> Move
    {
        var max = 500000;
        for (locStart, locEnd) in getAllMoves(game)
        {
            game.makeMove((locStart, locEnd))
            score = -1*search(depth - 1, game: game)
            if score > max
            {
                bestMove = (locStart, locEnd)
                max = score;
            }
           // game.undoLastMove()
        }
        return bestMove
    }

    
    static func search(depth: Int, game: Game) -> Int
    {
        if depth == 0
        {
            return evaluateBoard(game)
        }
        var max = 500000;
        for (locStart, locEnd) in getAllMoves(game)
        {
            game.makeMove((locStart, locEnd))
            score = -1*search(depth - 1, game: game)
            if score > max
            {
                bestMove = (locStart, locEnd)
                max = score;
            }
            //game.undoLastmove
        }
            return max
    }
    
    static func getAllMoves(game: Game) -> [(Location, Location)]
    {
        var moves : [(Location, Location)] = []
        for (location, _) in game.board
        {
            moves += mapLocToMove(location, game: game)
        }
        return moves
    }
    
    
    //I still think that validMoves might want to return a [Move], rather than a [Location]
    //No reason for it not to (except needing to refactor code)
    static func mapLocToMove(location: Location, game: Game) -> [(Location, Location)]
    {
        let moveEnds = game.validMoves(location)
        var allMoves : [(Location, Location)] = []
        for loc in moveEnds
        {
            allMoves += [(location, loc)]
        }
        return allMoves
    }
    
    static func evaluateBoard(game: Game) -> Int
    {
        var boardValue = 0
        var whiteBoardValue = 0
        var blackBoardValue = 0
        
        for (location, piece) in game.board
        {
            if piece.color == .White
            {
                if piece.kind == .King
                {
                   whiteBoardValue += 20000
                   whiteBoardValue += KingTable[convertToWhiteArrayIndex(location)]
                    
                }
                if piece.kind == .Queen
                {
                    whiteBoardValue += 900
                    whiteBoardValue += QueenTable[convertToWhiteArrayIndex(location)]
                }
                if piece.kind == .Bishop
                {
                    whiteBoardValue += 300
                    whiteBoardValue += BishopTable[convertToWhiteArrayIndex(location)]
                }
                if piece.kind == .Knight
                {
                    whiteBoardValue += 300
                    whiteBoardValue += KnightTable[convertToWhiteArrayIndex(location)]
                }
                if piece.kind == .Rook
                {
                    whiteBoardValue += 500
                    whiteBoardValue += RookTable[convertToWhiteArrayIndex(location)]
                }
                if piece.kind == .Pawn
                {
                    whiteBoardValue += 100
                    whiteBoardValue += PawnTable[convertToWhiteArrayIndex(location)]
                }
            }
            if piece.color == .Black
            {
                if piece.kind == .King
                {
                    blackBoardValue += 20000
                    blackBoardValue += KingTable[convertToBlackArrayIndex(location)]
                }
                if piece.kind == .Queen
                {
                    blackBoardValue += 900
                    blackBoardValue += QueenTable[convertToBlackArrayIndex(location)]
                }
                if piece.kind == .Bishop
                {
                    blackBoardValue += 300
                    blackBoardValue += BishopTable[convertToBlackArrayIndex(location)]
                }
                if piece.kind == .Knight
                {
                    blackBoardValue += 300
                    blackBoardValue += KnightTable[convertToBlackArrayIndex(location)]
                }
                if piece.kind == .Rook
                {
                    blackBoardValue += 500
                    blackBoardValue += RookTable[convertToBlackArrayIndex(location)]
                }
                if piece.kind == .Pawn
                {
                    blackBoardValue += 100
                    blackBoardValue += PawnTable[convertToBlackArrayIndex(location)]
                }
            }
        }
        
        boardValue = whiteBoardValue - blackBoardValue
        
        if game.activeColor == .Black
        {
            boardValue *= -1
        }
        return boardValue
    }
    
    static func convertToWhiteArrayIndex(loc: Location) -> Int
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
    
    static func convertToBlackArrayIndex(loc: Location) -> Int
    {
        let y = (loc.rank.value - 1)*8
        var x = 0
    
        
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
    
    static let KnightTable =
    [-50,-40,-30,-30,-30,-30,-40,-50,
        -40,-20,  0,  0,  0,  0,-20,-40,
        -30,  0, 10, 15, 15, 10,  0,-30,
        -30,  5, 15, 20, 20, 15,  5,-30,
        -30,  0, 15, 20, 20, 15,  0,-30,
        -30,  5, 10, 15, 15, 10,  5,-30,
        -40,-20,  0,  5,  5,  0,-20,-40,
        -50,-40,-30,-30,-30,-30,-40,-50,]
    
    static let BishopTable =
    [-20,-10,-10,-10,-10,-10,-10,-20,
        -10,  0,  0,  0,  0,  0,  0,-10,
        -10,  0,  5, 10, 10,  5,  0,-10,
        -10,  5,  5, 10, 10,  5,  5,-10,
        -10,  0, 10, 10, 10, 10,  0,-10,
        -10, 10, 10, 10, 10, 10, 10,-10,
        -10,  5,  0,  0,  0,  0,  5,-10,
        -20,-10,-10,-10,-10,-10,-10,-20,]
    
    static let PawnTable =
    [0,  0,  0,  0,  0,  0,  0,  0,
        50, 50, 50, 50, 50, 50, 50, 50,
        10, 10, 20, 30, 30, 20, 10, 10,
         5,  5, 10, 25, 25, 10,  5,  5,
         0,  0,  0, 20, 20,  0,  0,  0,
         5, -5,-10,  0,  0,-10, -5,  5,
         5, 10, 10,-20,-20, 10, 10,  5,
         0,  0,  0,  0,  0,  0,  0,  0,]
    
    static let QueenTable =
    [-20,-10,-10, -5, -5,-10,-10,-20,
        -10,  0,  0,  0,  0,  0,  0,-10,
        -10,  0,  5,  5,  5,  5,  0,-10,
         -5,  0,  5,  5,  5,  5,  0, -5,
          0,  0,  5,  5,  5,  5,  0, -5,
        -10,  5,  5,  5,  5,  5,  0,-10,
        -10,  0,  5,  0,  0,  0,  0,-10,
        -20,-10,-10, -5, -5,-10,-10,-20,]
    
    static let RookTable =
    [0,  0,  0,  0,  0,  0,  0,  0,
         5, 10, 10, 10, 10, 10, 10,  5,
        -5,  0,  0,  0,  0,  0,  0, -5,
        -5,  0,  0,  0,  0,  0,  0, -5,
        -5,  0,  0,  0,  0,  0,  0, -5,
        -5,  0,  0,  0,  0,  0,  0, -5,
        -5,  0,  0,  0,  0,  0,  0, -5,
         0,  0,  0,  5,  5,  0,  0,  0,]
    
    static let KingTable =
    [-30,-40,-40,-50,-50,-40,-40,-30,
        -30,-40,-40,-50,-50,-40,-40,-30,
        -30,-40,-40,-50,-50,-40,-40,-30,
        -30,-40,-40,-50,-50,-40,-40,-30,
        -20,-30,-30,-40,-40,-30,-30,-20,
        -10,-20,-20,-20,-20,-20,-20,-10,
         20, 20,  0,  0,  0,  0, 20, 20,
         20, 30, 10,  0,  0, 10, 30, 20,]
    
}