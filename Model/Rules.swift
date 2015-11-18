//
//  Rules.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

struct Rules {
    static func directions(game: Game, piece: Piece, start: Location) -> [[Location]]
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
                start.toSoutheast.take(1),start.toSouthwest.take(1),
                castlingMoves(game, piece:piece)]
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
            for direction in Rules.directions(game, piece:piece, start: start) {
                for location in direction {
                    //do not use switch here, because we need to 'break' out of for loop early
                    if piece.kind == .Pawn {
                        if let color = game.colorOfPieceAtLocation(location) {
                            if color != piece.color {
                                if location.file != start.file {
                                    if !Rules.isPlayerInCheckAfterMove(game, move:(start,location)) {
                                        moves.append(location)
                                    }
                                }
                            } else {
                                if location.file == start.file {
                                    break
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
    
    // Returns the Castling locations that the King as available
    static func castlingMoves(game:Game, piece:Piece) -> [Location] {
        var moves: [Location] = []
        //FIXME: check if King is in check; if so return moves
        if piece == Piece(color: .White, kind: .King) {
            if game.whiteHasKingSideCastleAvailable {
                if game.board[Location(rank: 1, file: .F)] == nil &&
                    game.board[Location(rank: 1, file: .G)] == nil {
                        //FIXME Check for check on f1
                        moves.append(Location(rank: 1, file: .G))
                }
            }
            if game.whiteHasQueenSideCastleAvailable {
                if game.board[Location(rank: 1, file: .B)] == nil &&
                    game.board[Location(rank: 1, file: .C)] == nil &&
                    game.board[Location(rank: 1, file: .D)] == nil {
                        //FIXME Check for check on d1
                        moves.append(Location(rank: 1, file: .C))
                }
            }
        }
        if piece == Piece(color: .Black, kind: .King) {
            if game.blackHasKingSideCastleAvailable {
                if game.board[Location(rank: 8, file: .F)] == nil &&
                    game.board[Location(rank: 8, file: .G)] == nil {
                        //FIXME Check for check on f8
                        moves.append(Location(rank: 8, file: .G))
                }
            }
            if game.blackHasQueenSideCastleAvailable {
                if game.board[Location(rank: 8, file: .B)] == nil &&
                    game.board[Location(rank: 8, file: .C)] == nil &&
                    game.board[Location(rank: 8, file: .D)] == nil {
                        //FIXME Check for check on d8
                        moves.append(Location(rank: 8, file: .C))
                }
            }
            
        }
        return moves
    }
    
    // Returns an Location? vulnerable to enPassant; does not check if move is legal
    // (i.e., pawn may be pinned or blocked)
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
    
    // Returns the Rook's counter-part move to the King's castle move
    // does not check if the castle is legal at this point in the game
    // will return nil if the move provided is not a King's castle move
    static func rookMoveWhileCastling(game: Game, move: Move) -> Move? {
        if let piece = game.board[move.start] {
            if piece.kind == .King {
                let blackKing = Location(rank:8, file:.E)
                let whiteKing = Location(rank:1, file:.E)
                if move == (blackKing, Location(rank:8, file:.G)) {
                    return(Location(rank:8, file:.H), Location(rank:8, file:.F))
                }
                if move == (blackKing, Location(rank:8, file:.C)) {
                    return(Location(rank:8, file:.A), Location(rank:8, file:.D))
                }
                if move == (whiteKing, Location(rank:1, file:.G)) {
                    return(Location(rank:1, file:.H), Location(rank:1, file:.F))
                }
                if move == (whiteKing, Location(rank:1, file:.C)) {
                    return(Location(rank:1, file:.A), Location(rank:1, file:.D))
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
    
    static func isPawnPromotion(game:Game, move:Move) -> Bool {
        if let piece = game.board[move.start] {
            if piece.kind == .Pawn {
                if move.end.rank == Rank.maxValue  || move.end.rank == Rank.minValue {
                    return true
                }
            }
        }
        return false
    }
    
    static func promotionPiece(game:Game, move:Move, promotionKind:Kind) -> Piece? {
        if isPawnPromotion(game, move:move) {
            let piece = game.board[move.start]!
            return Piece(color: piece.color, kind: promotionKind)
        }
        return nil
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
