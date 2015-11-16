//
//  Rule.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

import Foundation

struct Rules {
    static func directions(piece: Piece, start: Location) -> [[Location]]
    {
        
        switch piece.kind {
        case .Rook:
            return [start.toNorth,start.toSouth,start.toEast,start.toWest]
        case .Bishop:
            return [start.toNortheast,start.toNorthwest,start.toSoutheast,start.toSouthwest]
        case .Queen:
            return [start.toNorth,start.toSouth,start.toEast,start.toWest,
                start.toNortheast,start.toNorthwest,start.toSoutheast,start.toSouthwest]
        case .King:
            return [start.toNorth.firstOrEmpty(),start.toSouth.firstOrEmpty(),
                start.toEast.firstOrEmpty(),start.toWest.firstOrEmpty(),
                start.toNortheast.firstOrEmpty(),start.toNorthwest.firstOrEmpty(),
                start.toSoutheast.firstOrEmpty(),start.toSouthwest.firstOrEmpty()]
        case .Knight:
            //FIXME: Implement
            return [[start]]
        case .Pawn:
            //FIXME: Implement
            return [[start]]
        }
    }
    
    static func validMoves(game:Game, start:Location) -> [Location]
    {
        var moves: [Location] = []
        if let piece = game.board[start]
        {
            if piece.color == game.activeColor {
                
            } else {
                print("You can't move an opponents piece")
                return moves
            }
            //FIXME: check for Check, enPassant, and Castling
            for direction in Rules.directions(piece, start: start) {
                for location in direction {
                    if let conflictPiece = game.board[location] {
                        if conflictPiece.color != piece.color {
                            moves.append(location)
                        }
                        break
                    } else {
                        // no piece at location
                        moves.append(location)
                    }
                }
            }
        } else {
            print("No piece at \(start)")
        }
        return moves
    }
}

//typealias Rule = (Board, Location) -> [Location]

struct Rule {
    let name: String
}

