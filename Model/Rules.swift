//
//  Rules.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

struct Rules {
    static func validMoves(board: Board, start:Location) -> [Location] {
        var moves: [Location] = []
        if let piece = board.pieceAt(start)
        {
            if piece.color != board.activeColor {
                print("You can't move an opponents piece")
                return moves
            }
            for direction in Rules.directions(board, piece:piece, start: start) {
                for location in direction {
                    //do not use switch here, because we need to 'break' out of for loop early
                    if piece.kind == .Pawn {
                        if let color = board.pieceAt(location)?.color {
                            if color != piece.color {
                                if location.file != start.file {
                                    if !Rules.isPlayerInCheckAfterMove(board, activeColor: board.activeColor, move:(start,location)) {
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
                                location == board.enPassantTargetSquare {
                                if !Rules.isPlayerInCheckAfterMove(board, activeColor: board.activeColor, move:(start,location)) {
                                    moves.append(location)
                                }
                            }
                        }
                    } else {
                        if let color = board.pieceAt(location)?.color {
                            if color != piece.color {
                                if !Rules.isPlayerInCheckAfterMove(board, activeColor: board.activeColor, move:(start,location)) {
                                    moves.append(location)
                                }
                            }
                            break
                        } else {
                            // no piece at location; add to list
                            if !Rules.isPlayerInCheckAfterMove(board, activeColor: board.activeColor, move:(start,location)) {
                                moves.append(location)
                            }
                        }
                    }
                }
            }
        } else {
            print("No piece at \(start)")
        }
        return moves.filter {!isPlayerInCheckAfterMove(board, activeColor: board.activeColor, move:(start:start, end:$0))}
    }

    
    static func directions(board: Board, piece: Piece, start: Location) -> [[Location]] {
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
                castlingMoves(board, piece:piece)]
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
    
    
    // Returns the Castling locations that the King as available
    static func castlingMoves(board: Board, piece:Piece) -> [Location] {
        var moves: [Location] = []
        if isPlayerInCheck(board, kingsColor: board.activeColor) {
            return moves
        }
        if piece == Piece(color: .White, kind: .King) {
            if board.castlingOptions.contains(.WhiteKingSide) {
                if board.isEmptyAt(Location(rank: 1, file: .F)) &&
                    board.isEmptyAt(Location(rank: 1, file: .G)) {
                        let intermediateMove = (start:Location(rank: 1, file: .E),
                                                  end:Location(rank: 1, file: .F))
                        if !isPlayerInCheckAfterMove(board, activeColor: board.activeColor, move:intermediateMove) {
                            moves.append(Location(rank: 1, file: .G))
                        }
                }
            }
            if board.castlingOptions.contains(.WhiteQueenSide) {
                if board.isEmptyAt(Location(rank: 1, file: .B)) &&
                    board.isEmptyAt(Location(rank: 1, file: .C)) &&
                    board.isEmptyAt(Location(rank: 1, file: .D)) {
                        let intermediateMove = (start:Location(rank: 1, file: .E),
                            end:Location(rank: 1, file: .D))
                        if !isPlayerInCheckAfterMove(board, activeColor: board.activeColor, move:intermediateMove) {
                            moves.append(Location(rank: 1, file: .C))
                        }
                }
            }
        }
        if piece == Piece(color: .Black, kind: .King) {
            if board.castlingOptions.contains(.BlackKingSide) {
                if board.isEmptyAt(Location(rank: 8, file: .F)) &&
                    board.isEmptyAt(Location(rank: 8, file: .G)) {
                        let intermediateMove = (start:Location(rank: 8, file: .E),
                            end:Location(rank: 8, file: .F))
                        if !isPlayerInCheckAfterMove(board, activeColor: board.activeColor, move:intermediateMove) {
                            moves.append(Location(rank: 8, file: .G))
                        }
                }
            }
            if board.castlingOptions.contains(.BlackQueenSide) {
                if board.isEmptyAt(Location(rank: 8, file: .B)) &&
                    board.isEmptyAt(Location(rank: 8, file: .C)) &&
                    board.isEmptyAt(Location(rank: 8, file: .D)) {
                        let intermediateMove = (start:Location(rank: 8, file: .E),
                            end:Location(rank: 8, file: .D))
                        if !isPlayerInCheckAfterMove(board, activeColor: board.activeColor, move:intermediateMove) {
                            moves.append(Location(rank: 8, file: .C))
                        }
                }
            }
            
        }
        return moves
    }
    
    
    // Returns an Location? vulnerable to enPassant; does not check if move is legal
    // (i.e., pawn may be pinned or blocked)
    static func enPassantTargetSquare(board:Board, move:Move) -> Location?{
        if let piece = board.pieceAt(move.start) {
            if piece.kind == .Pawn {
                switch piece.color {
                case .White:
                    if move.start.rank == 2 && move.end.rank == 4 &&
                        move.start.file == move.end.file {
                            let targetSquare = Location(rank:3, file:move.start.file)
                            if board.isEmptyAt(targetSquare) && board.isEmptyAt(move.end) {
                                return targetSquare
                            }
                    }
                case .Black:
                    if move.start.rank == 7 && move.end.rank == 5 &&
                        move.start.file == move.end.file {
                            let targetSquare = Location(rank:6, file:move.start.file)
                            if board.isEmptyAt(targetSquare) && board.isEmptyAt(move.end) {
                                return targetSquare
                            }
                    }
                }
            }
        }
        return nil
    }

    // Returns the Rook's counter-part move to the King's castle move
    // does not check if the castle is legal at this point in the board
    // will return nil if the move provided is not a King's castle move
    static func rookMoveWhileCastling(board:Board, move: Move) -> Move? {
        if let piece = board.pieceAt(move.start) {
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

    static func doesActivePlayerHaveMoves(board: Board) -> Bool {
        for (location,piece) in board {
            if piece.color == board.activeColor {
                let validMoves = Rules.validMoves(board, start: location)
                if validMoves.count > 0 {
                    return true
                }
            }
        }
        return false
    }

    static func isPlayerInCheckAfterMove(board:Board, activeColor: Color, move: Move) -> Bool {
        //returns true if this move leaves the player in check
        //FIXME:  This results in an infinite loop, checking the validity of the move which checks if a player is in check...
        if let (newBoard,_) = board.makeMove(move) {
            return isPlayerInCheck(newBoard, kingsColor:activeColor)
        }
        return false
    }
    
    static func isActivePlayerInCheck(board:Board) -> Bool{
        //returns true if the player with color is in check
        return isPlayerInCheck(board, kingsColor:board.activeColor)
    }

    static func isPlayerInCheck(board:Board, kingsColor:Color) -> Bool{
        if let kingsSquare = board.locationOfKing(kingsColor) {
            //look for an attacking opponent from the kings perspective
            //Check horizontal and vertical attacks
            for direction in [kingsSquare.toNorth, kingsSquare.toSouth,  kingsSquare.toEast,kingsSquare.toWest] {
                for location in direction {
                    if let otherPiece = board.pieceAt(location) {
                        if otherPiece.color == kingsColor {
                            break
                        } else {
                            if otherPiece.kind == .Queen || otherPiece.kind == .Rook {
                                //print("eliminating move because it exposes player to check from queen/rook")
                                return true
                            } else {
                                break
                            }
                        }
                    }
                }
            }
            //Check diagonal attacks
            for direction in [kingsSquare.toNortheast, kingsSquare.toSoutheast,  kingsSquare.toNorthwest,kingsSquare.toSouthwest] {
                for location in direction {
                    if let otherPiece = board.pieceAt(location) {
                        if otherPiece.color == kingsColor {
                            break
                        } else {
                            if otherPiece.kind == .Queen || otherPiece.kind == .Bishop {
                                //print("eliminating move \(move) because it exposes player to check from queen/bishop")
                                return true
                            } else {
                                break
                            }
                        }
                    }
                }
            }
            //Check knight attacks
            let offsets = [(-2,1), (-1,2), (1,2), (2,1), (2,-1), (1,-2), (-1,-2), (-2,-1)]
            let directions: [[Location]] = offsets.map {
                if let newRank = kingsSquare.rank + $0 {
                    if let newFile = kingsSquare.file + $1 {
                        return [Location(rank: newRank, file: newFile)]
                    }
                }
                return []
            }
            for direction in directions {
                for location in direction {
                    if let otherPiece = board.pieceAt(location) {
                        if otherPiece.color == kingsColor {
                            break
                        } else {
                            if otherPiece.kind == .Knight {
                                //print("eliminating move \(move) because it exposes player to check from knight")
                                return true
                            } else {
                                break
                            }
                        }
                    }
                }
            }
            //Check pawn attacks
            var pawnDirections:[[Location]] = [[]]
            if kingsColor == .White {
                pawnDirections = [kingsSquare.toNortheast.take(1), kingsSquare.toNorthwest.take(1)]
            } else {
                pawnDirections = [kingsSquare.toSoutheast.take(1), kingsSquare.toSouthwest.take(1)]
            }
            for direction in pawnDirections {
                for location in direction {
                    if let otherPiece = board.pieceAt(location) {
                        if otherPiece.color == kingsColor {
                            break
                        } else {
                            if otherPiece.kind == .Pawn {
                                //print("eliminating move \(move) because it exposes player to check from a pawn")
                                return true
                            } else {
                                break
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    
    static func isPawnPromotion(board: Board, move:Move) -> Bool {
        if let piece = board.pieceAt(move.start) {
            if piece.kind == .Pawn {
                if move.end.rank == Rank.maxValue  || move.end.rank == Rank.minValue {
                    return true
                }
            }
        }
        return false
    }
    
    static func promotionPiece(board: Board, move:Move, promotionKind:Kind) -> Piece? {
        if isPawnPromotion(board, move:move) {
            let piece = board.pieceAt(move.start)!
            return Piece(color: piece.color, kind: promotionKind)
        }
        return nil
    }
    
    static func resetHalfMoveClock(board: Board, move : Move) -> Bool {
        //Rule 9.3: 50 moves without movement of any pawn or a capture
        if board.pieceAt(move.end) != nil || board.pieceAt(move.start)?.kind == .Pawn {
            return true
        }
        return false
    }

    static func explainMove(board: Board, move:Move) -> String {
        return "explain \(move)"
        //FIXME: Implement
    }

    static func newCastlingOptions(castlingOptions: CastlingOptions,location:Location) -> CastlingOptions {
        var newCastlingOptions = castlingOptions
        //Options decrease if king or rook moves
        if location == Location(rank:1, file:.E) {
            newCastlingOptions.subtractInPlace(.BothWhite)
        }
        if location == Location(rank:1, file:.A) {
            newCastlingOptions.subtractInPlace(.WhiteQueenSide)
        }
        if location == Location(rank:1, file:.H) {
            newCastlingOptions.subtractInPlace(.WhiteKingSide)
        }
        if location == Location(rank:8, file:.E) {
            newCastlingOptions.subtractInPlace(.BothBlack)
        }
        if location == Location(rank:8, file:.A) {
            newCastlingOptions.subtractInPlace(.BlackQueenSide)
        }
        if location == Location(rank:8, file:.H) {
            newCastlingOptions.subtractInPlace(.BlackKingSide)
        }
        return newCastlingOptions
    }

    static func enPassantCaptureSquare(board: Board, move: Move) -> Location? {
        if let piece = board.pieceAt(move.start) {
            if piece.kind == .Pawn && move.end == board.enPassantTargetSquare {
                return Location(rank:move.start.rank, file:move.end.file)
            }
        }
        return nil
    }

    //MARK: Default Starting Board
    
    static let defaultStartingBoard = [
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
