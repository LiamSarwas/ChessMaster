//
//  Rules.swift
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
            return [start.toNorth.take(1),start.toSouth.take(1),
                start.toEast.take(1),start.toWest.take(1),
                start.toNortheast.take(1),start.toNorthwest.take(1),
                start.toSoutheast.take(1),start.toSouthwest.take(1)]
        case .Knight:
            let offsets = [(-2,1), (-1,2), (1,2), (2,1), (2,-1), (1,-2), (-1,-2), (-2,-1)]
            return offsets.map {
                if let newRank = start.rank + $0 {
                    if let newFile = start.file + $1 {
                        return [Location(rank: newRank, file: newFile)]
                    }
                }
                return []
            }
        case .Pawn:
            switch piece.color {
            case .White:
                let homeRank = start.rank == 2
                let forwardCount = homeRank ? 2 : 1
                return [start.toNorth.take(forwardCount),
                    start.toNortheast.take(1), start.toNorthwest.take(1)]
            case .Black:
                let homeRank = start.rank == 7
                let forwardCount = homeRank ? 2 : 1
                return [start.toSouth.take(forwardCount),
                    start.toSoutheast.take(1), start.toSouthwest.take(1)]
            }
        }
    }
    
    static func validMoves(game:Game, start:Location) -> [Location]
    {
        var moves: [Location] = []
        if let piece = game.board[start]
        {
            if piece.color != game.activeColor {
                print("You can't move an opponents piece")
                return moves
            }
            //FIXME: check Castling
            for direction in Rules.directions(piece, start: start) {
                for location in direction {
                    //do not use switch here, because we need to 'vreak' out of for loop early
                    if piece.kind == .Pawn {
                        if let color = game.colorOfPieceAtLocation(location) {
                            if color != piece.color {
                                if location.file != start.file {
                                    if !Rules.isPlayerInCheckAfterMove(game, move:(start,location)) {
                                        moves.append(location)
                                    }
                                }
                            }
                        } else {
                            if location.file == start.file ||
                                location == game.enPassantTargetSquare {
                                if !Rules.isPlayerInCheckAfterMove(game, move:(start,location)) {
                                    moves.append(location)
                                }
                            }
                        }
                    } else {
                        if let color = game.colorOfPieceAtLocation(location) {
                            if color != piece.color {
                                if !Rules.isPlayerInCheckAfterMove(game, move:(start,location)) {
                                    moves.append(location)
                                }
                            }
                            break
                        } else {
                            // no piece at location; add to list
                            if !Rules.isPlayerInCheckAfterMove(game, move:(start,location)) {
                                moves.append(location)
                            }
                        }
                    }
                }
            }
        } else {
            print("No piece at \(start)")
        }
        return moves
    }

    static func enPassantTargetSquare(game: Game, move:Move) -> Location?{
        if let piece = game.board[move.start] {
            if piece.kind == .Pawn {
                switch piece.color {
                case .White:
                    if move.start.rank == 2 && move.end.rank == 4 &&
                        move.start.file == move.end.file {
                            let targetSquare = Location(rank:3, file:move.start.file)
                            if game.board[targetSquare] == nil && game.board[move.end] == nil {
                                return targetSquare
                            }
                    }
                case .Black:
                    if move.start.rank == 7 && move.end.rank == 5 &&
                        move.start.file == move.end.file {
                            let targetSquare = Location(rank:6, file:move.start.file)
                            if game.board[targetSquare] == nil && game.board[move.end] == nil {
                                return targetSquare
                            }
                    }
                }
            }
        }
        return nil
    }

    static func isPlayerInCheckAfterMove(game:Game, move: Move) -> Bool{
        //returns true if this move leaves the player in check
        //FIXME: implement
        return false
    }

    // Mark - Default Starting Board
    
    static let defaultStartingBoard : Board = [
        Location(rank:1, file:.A): Piece(color:.White, kind:.Rook),
        Location(rank:1, file:.B): Piece(color:.White, kind:.Knight),
        Location(rank:1, file:.C): Piece(color:.White, kind:.Bishop),
        Location(rank:1, file:.D): Piece(color:.White, kind:.Queen),
        Location(rank:1, file:.E): Piece(color:.White, kind:.King),
        Location(rank:1, file:.F): Piece(color:.White, kind:.Bishop),
        Location(rank:1, file:.G): Piece(color:.White, kind:.Knight),
        Location(rank:1, file:.H): Piece(color:.White, kind:.Rook),
        
        Location(rank:2, file:.A): Piece(color:.White, kind:.Pawn),
        Location(rank:2, file:.B): Piece(color:.White, kind:.Pawn),
        Location(rank:2, file:.C): Piece(color:.White, kind:.Pawn),
        Location(rank:2, file:.D): Piece(color:.White, kind:.Pawn),
        Location(rank:2, file:.E): Piece(color:.White, kind:.Pawn),
        Location(rank:2, file:.F): Piece(color:.White, kind:.Pawn),
        Location(rank:2, file:.G): Piece(color:.White, kind:.Pawn),
        Location(rank:2, file:.H): Piece(color:.White, kind:.Pawn),
        
        Location(rank:7, file:.A): Piece(color:.Black, kind:.Pawn),
        Location(rank:7, file:.B): Piece(color:.Black, kind:.Pawn),
        Location(rank:7, file:.C): Piece(color:.Black, kind:.Pawn),
        Location(rank:7, file:.D): Piece(color:.Black, kind:.Pawn),
        Location(rank:7, file:.E): Piece(color:.Black, kind:.Pawn),
        Location(rank:7, file:.F): Piece(color:.Black, kind:.Pawn),
        Location(rank:7, file:.G): Piece(color:.Black, kind:.Pawn),
        Location(rank:7, file:.H): Piece(color:.Black, kind:.Pawn),
        
        Location(rank:8, file:.A): Piece(color:.Black, kind:.Rook),
        Location(rank:8, file:.B): Piece(color:.Black, kind:.Knight),
        Location(rank:8, file:.C): Piece(color:.Black, kind:.Bishop),
        Location(rank:8, file:.D): Piece(color:.Black, kind:.Queen),
        Location(rank:8, file:.E): Piece(color:.Black, kind:.King),
        Location(rank:8, file:.F): Piece(color:.Black, kind:.Bishop),
        Location(rank:8, file:.G): Piece(color:.Black, kind:.Knight),
        Location(rank:8, file:.H): Piece(color:.Black, kind:.Rook),
    ]

}

//typealias Rule = (Board, Location) -> [Location]

struct Rule {
    let name: String
}

