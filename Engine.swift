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
   
    static func getMove(_ board: Board) -> Move?
    {
//        print("Board Score = \(evaluateBoard(board)) at Start")
        var bestMove:Move?
        var bestScore: Int = Int.min
        for move in getAllMoves(board)
        {
            if let (newboard, _) = board.makeMoveWithoutValidation(move) {
                let baseScore = evaluateBoard(newboard)
//                print("Board Score = \(baseScore) after move \(move)")
                let score = baseScore - search(2, board: newboard)
                if bestScore < score {
                    bestScore = score
                    bestMove = move
                }
            }
        }
        return bestMove
    }

    
    static func search(_ depth: Int, board: Board) -> Int
    {
        if depth == 0 { return 0 }
//        print("\(depth)Board Score = \(evaluateBoard(board)) at Start")
        var bestScore: Int = Int.min
        for move in getAllMoves(board)
        {
            if let (newboard, _) = board.makeMoveWithoutValidation(move) {
                let baseScore = evaluateBoard(newboard)
//                print("\(depth)Board Score = \(baseScore) after move \(move)")
                let score = baseScore - search(depth-1, board: newboard)
                if bestScore < score {
                    bestScore = score
                }
            }
        }
        return bestScore
    }
    
    static func getAllMoves(_ board: Board) -> [Move]
    {
        var moves : [Move] = []
        for location in board.locationsOfPiecesOfColor(board.activeColor)
        {
            moves += Rules.validMoves(board, start: location).map{(location, $0)}
        }
        return moves
    }
    
    
    static func evaluateBoard(_ board: Board) -> Int
    {
        var whiteBoardValue = 0
        var blackBoardValue = 0
        
        for (location, piece) in board
        {
            if piece.color == .white
            {
                if piece.kind == .king
                {
                   whiteBoardValue += 20000
                   whiteBoardValue += KingTable[convertToWhiteArrayIndex(location)]
                    
                }
                if piece.kind == .queen
                {
                    whiteBoardValue += 900
                    whiteBoardValue += QueenTable[convertToWhiteArrayIndex(location)]
                }
                if piece.kind == .bishop
                {
                    whiteBoardValue += 300
                    whiteBoardValue += BishopTable[convertToWhiteArrayIndex(location)]
                }
                if piece.kind == .knight
                {
                    whiteBoardValue += 300
                    whiteBoardValue += KnightTable[convertToWhiteArrayIndex(location)]
                }
                if piece.kind == .rook
                {
                    whiteBoardValue += 500
                    whiteBoardValue += RookTable[convertToWhiteArrayIndex(location)]
                }
                if piece.kind == .pawn
                {
                    whiteBoardValue += 100
                    whiteBoardValue += PawnTable[convertToWhiteArrayIndex(location)]
                }
            }
            if piece.color == .black
            {
                if piece.kind == .king
                {
                    blackBoardValue += 20000
                    blackBoardValue += KingTable[convertToBlackArrayIndex(location)]
                }
                if piece.kind == .queen
                {
                    blackBoardValue += 900
                    blackBoardValue += QueenTable[convertToBlackArrayIndex(location)]
                }
                if piece.kind == .bishop
                {
                    blackBoardValue += 300
                    blackBoardValue += BishopTable[convertToBlackArrayIndex(location)]
                }
                if piece.kind == .knight
                {
                    blackBoardValue += 300
                    blackBoardValue += KnightTable[convertToBlackArrayIndex(location)]
                }
                if piece.kind == .rook
                {
                    blackBoardValue += 500
                    blackBoardValue += RookTable[convertToBlackArrayIndex(location)]
                }
                if piece.kind == .pawn
                {
                    blackBoardValue += 100
                    blackBoardValue += PawnTable[convertToBlackArrayIndex(location)]
                }
            }
        }
        
        // We are evaluating the board after the active player made a move, so the player is now inActive
        return board.inActiveColor == .black ? blackBoardValue - whiteBoardValue : whiteBoardValue - blackBoardValue
    }
    
    static func convertToWhiteArrayIndex(_ location: Location) -> Int
    {
        // a8 -> 0; h8 -> 7; a1 -> 56; h1 -> 63
        return 64 - (8 * Int(location.rank)) + (Int(location.file) - 1)
    }
    
    static func convertToBlackArrayIndex(_ location: Location) -> Int
    {
        // a8 -> 56; h8 -> 63; a1 -> 0; h1 -> 7
        return (8 * (Int(location.rank) - 1)) + (Int(location.file) - 1)
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
