//
//  Rules.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

struct Rules {

    static func startingLocation(_ board: Board, piece movingPiece: Piece, end: Location) -> [Location] {
        // Given a board state before a move and the final location for a piece after a potential move
        // find the list of possible starting locations for that piece
        // This is used with PGN which does not always specify the stating location.
        var startingLocations : [Location] = []
        for (start,_) in board.filter({$1 == movingPiece}) {
            if validMoves(board, start: start).contains(end) {
                startingLocations.append(start)
            }
        }
        return startingLocations
    }

    static func validMoves(_ board: Board, start: Location) -> [Location] {
        var moves: [Location] = []
        if let piece = board.pieceAt(start)
        {
            if piece.color != board.activeColor {
                print("You can't move an opponents piece")
                return moves
            }
            for direction in Rules.directions(board, piece: piece, start: start) {
                for location in direction {
                    // do not use switch here, because we need to 'break' out of for loop early
                    if piece.kind == .pawn {
                        if let color = board.pieceAt(location)?.color {
                            if color != piece.color {
                                if location.file != start.file {
                                    if !Rules.isPlayerInCheckAfterMove(board, activeColor: board.activeColor, move:(start, location)) {
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
                                if !Rules.isPlayerInCheckAfterMove(board, activeColor: board.activeColor, move: (start, location)) {
                                    moves.append(location)
                                }
                            }
                        }
                    } else {
                        if let color = board.pieceAt(location)?.color {
                            if color != piece.color {
                                if !Rules.isPlayerInCheckAfterMove(board, activeColor: board.activeColor, move: (start, location)) {
                                    moves.append(location)
                                }
                            }
                            break
                        } else {
                            // no piece at location; add to list
                            if !Rules.isPlayerInCheckAfterMove(board, activeColor: board.activeColor, move: (start, location)) {
                                moves.append(location)
                            }
                        }
                    }
                }
            }
        } else {
            print("No piece at \(start)")
        }
        return moves.filter {!isPlayerInCheckAfterMove(board, activeColor: board.activeColor, move: (start, $0))}
    }

    
    static func directions(_ board: Board, piece: Piece, start: Location) -> [[Location]] {
        switch piece.kind {
        case .rook:
            return [start.toNorth, start.toSouth, start.toEast, start.toWest]
        case .bishop:
            return [start.toNortheast, start.toNorthwest, start.toSoutheast, start.toSouthwest]
        case .queen:
            return [start.toNorth, start.toSouth, start.toEast, start.toWest,
                start.toNortheast, start.toNorthwest, start.toSoutheast, start.toSouthwest]
        case .king:
            return [start.toNorth.take(1), start.toSouth.take(1),
                start.toEast.take(1), start.toWest.take(1),
                start.toNortheast.take(1), start.toNorthwest.take(1),
                start.toSoutheast.take(1), start.toSouthwest.take(1),
                castlingMoves(board, piece: piece)]
        case .knight:
            let offsets = [(-2,1), (-1,2), (1,2), (2,1), (2,-1), (1,-2), (-1,-2), (-2,-1)]
            return offsets.map {
                if let newRank = start.rank + $0 {
                    if let newFile = start.file + $1 {
                        return [Location(file: newFile, rank: newRank)]
                    }
                }
                return []
            }
        case .pawn:
            switch piece.color {
            case .white:
                let homeRank = start.rank == Rank.r2
                let forwardCount = homeRank ? 2 : 1
                return [start.toNorth.take(forwardCount),
                    start.toNortheast.take(1), start.toNorthwest.take(1)]
            case .black:
                let homeRank = start.rank == Rank.r7
                let forwardCount = homeRank ? 2 : 1
                return [start.toSouth.take(forwardCount),
                    start.toSoutheast.take(1), start.toSouthwest.take(1)]
            }
        }
    }
    
    
    // Returns the Castling locations that the King as available
    static func castlingMoves(_ board: Board, piece: Piece) -> [Location] {
        var moves: [Location] = []
        if isPlayerInCheck(board, kingsColor: board.activeColor) {
            return moves
        }
        if piece == Piece.whiteKing {
            if board.castlingOptions.contains(.WhiteKingSide) {
                if board.isEmptyAt(f1) &&
                    board.isEmptyAt(g1) {
                        let intermediateMove = (e1, f1)
                        if !isPlayerInCheckAfterMove(board, activeColor: board.activeColor, move: intermediateMove) {
                            moves.append(g1)
                        }
                }
            }
            if board.castlingOptions.contains(.WhiteQueenSide) {
                if board.isEmptyAt(b1) &&
                    board.isEmptyAt(c1) &&
                    board.isEmptyAt(d1) {
                        let intermediateMove = (e1, d1)
                        if !isPlayerInCheckAfterMove(board, activeColor: board.activeColor, move: intermediateMove) {
                            moves.append(c1)
                        }
                }
            }
        }
        if piece == Piece.blackKing {
            if board.castlingOptions.contains(.BlackKingSide) {
                if board.isEmptyAt(f8) &&
                    board.isEmptyAt(g8) {
                        let intermediateMove = (e8, f8)
                        if !isPlayerInCheckAfterMove(board, activeColor: board.activeColor, move: intermediateMove) {
                            moves.append(g8)
                        }
                }
            }
            if board.castlingOptions.contains(.BlackQueenSide) {
                if board.isEmptyAt(b8) &&
                    board.isEmptyAt(c8) &&
                    board.isEmptyAt(d8) {
                        let intermediateMove = (e8, d8)
                        if !isPlayerInCheckAfterMove(board, activeColor: board.activeColor, move: intermediateMove) {
                            moves.append(c8)
                        }
                }
            }
            
        }
        return moves
    }
    
    
    // Returns an Location? vulnerable to enPassant; does not check if move is legal
    // (i.e., pawn may be pinned or blocked)
    static func enPassantTargetSquare(_ board: Board, move: Move) -> Location?{
        if let piece = board.pieceAt(move.start) {
            if piece.kind == .pawn {
                switch piece.color {
                case .white:
                    if move.start.rank == Rank.r2 && move.end.rank == Rank.r4 &&
                        move.start.file == move.end.file {
                            let targetSquare = Location(file: move.start.file, rank: Rank.r3)
                            if board.isEmptyAt(targetSquare) && board.isEmptyAt(move.end) {
                                return targetSquare
                            }
                    }
                case .black:
                    if move.start.rank == Rank.r7 && move.end.rank == Rank.r5 &&
                        move.start.file == move.end.file {
                            let targetSquare = Location(file: move.start.file, rank: Rank.r6)
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
    static func rookMoveWhileCastling(_ board: Board, move: Move) -> Move? {
        if board.pieceAt(move.start)?.kind == .king {
            let blackKingHome = e8
            let whiteKingHome = e1
            if move == (blackKingHome, g8) { return (h8, f8) }
            if move == (blackKingHome, c8) { return (a8, d8) }
            if move == (whiteKingHome, g1) { return (h1, f1) }
            if move == (whiteKingHome, c1) { return (a1, d1) }
        }
        return nil
    }

    static func doesActivePlayerHaveMoves(_ board: Board) -> Bool {
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

    static func isPlayerInCheckAfterMove(_ board: Board, activeColor: Color, move: Move) -> Bool {
        // returns true if this move leaves the player in check
        // validating the move will cause an infinte loop.
        if let (newBoard, _) = board.makeMoveWithoutValidation(move) {
            return isPlayerInCheck(newBoard, kingsColor: activeColor)
        }
        return false
    }
    
    static func isActivePlayerInCheck(_ board: Board) -> Bool{
        // returns true if the player with color is in check
        return isPlayerInCheck(board, kingsColor: board.activeColor)
    }

    static func isPlayerInCheck(_ board: Board, kingsColor: Color) -> Bool{
        if let kingsSquare = board.locationOfKing(kingsColor) {
            // look for an attacking opponent from the kings perspective
            // Check horizontal and vertical attacks
            for direction in [kingsSquare.toNorth, kingsSquare.toSouth, kingsSquare.toEast, kingsSquare.toWest] {
                for location in direction {
                    if let otherPiece = board.pieceAt(location) {
                        if otherPiece.color == kingsColor {
                            break
                        } else {
                            if otherPiece.kind == .queen || otherPiece.kind == .rook {
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
            for direction in [kingsSquare.toNortheast, kingsSquare.toSoutheast, kingsSquare.toNorthwest, kingsSquare.toSouthwest] {
                for location in direction {
                    if let otherPiece = board.pieceAt(location) {
                        if otherPiece.color == kingsColor {
                            break
                        } else {
                            if otherPiece.kind == .queen || otherPiece.kind == .bishop {
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
                        return [Location(file: newFile, rank: newRank)]
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
                            if otherPiece.kind == .knight {
                                // print("eliminating move \(move) because it exposes player to check from knight")
                                return true
                            } else {
                                break
                            }
                        }
                    }
                }
            }
            // Check pawn attacks
            var pawnDirections: [[Location]] = [[]]
            if kingsColor == .white {
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
                            if otherPiece.kind == .pawn {
                                // print("eliminating move \(move) because it exposes player to check from a pawn")
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
    
    static func isPawnPromotion(_ board: Board, move: Move) -> Bool {
        if let piece = board.pieceAt(move.start) {
            if piece.kind == .pawn {
                if move.end.rank == Rank.max  || move.end.rank == Rank.min {
                    return true
                }
            }
        }
        return false
    }
    
    static func promotionPiece(_ board: Board, move: Move, promotionKind: Kind) -> Piece? {
        if isPawnPromotion(board, move: move) {
            let piece = board.pieceAt(move.start)!
            return Piece(color: piece.color, kind: promotionKind)
        }
        return nil
    }
    
    static func resetHalfMoveClock(_ board: Board, move: Move) -> Bool {
        // Rule 9.3: 50 moves without movement of any pawn or a capture
        if board.pieceAt(move.end) != nil || board.pieceAt(move.start)?.kind == .pawn {
            return true
        }
        return false
    }

    static func explainMove(_ board: Board, move: Move) -> String {
        return "explain \(move)"
        // FIXME: Implement
    }

    static func newCastlingOptions(_ castlingOptions: CastlingOptions, location: Location) -> CastlingOptions {
        var newCastlingOptions = castlingOptions
        // Options decrease if king or rook moves
        if location == e1 {
            newCastlingOptions.subtract(.BothWhite)
        }
        if location == a1 {
            newCastlingOptions.subtract(.WhiteQueenSide)
        }
        if location == h1 {
            newCastlingOptions.subtract(.WhiteKingSide)
        }
        if location == e8 {
            newCastlingOptions.subtract(.BothBlack)
        }
        if location == a8 {
            newCastlingOptions.subtract(.BlackQueenSide)
        }
        if location == h8 {
            newCastlingOptions.subtract(.BlackKingSide)
        }
        return newCastlingOptions
    }

    static func enPassantCaptureSquare(_ board: Board, move: Move) -> Location? {
        if let piece = board.pieceAt(move.start) {
            if piece.kind == .pawn && move.end == board.enPassantTargetSquare {
                return Location(file: move.end.file, rank: move.start.rank)
            }
        }
        return nil
    }

    // MARK: - Default Starting Board
    
    static let defaultStartingBoard = [
        a1: Piece.whiteRook,
        b1: Piece.whiteKnight,
        c1: Piece.whiteBishop,
        d1: Piece.whiteQueen,
        e1: Piece.whiteKing,
        f1: Piece.whiteBishop,
        g1: Piece.whiteKnight,
        h1: Piece.whiteRook,
        
        a2: Piece.whitePawn,
        b2: Piece.whitePawn,
        c2: Piece.whitePawn,
        d2: Piece.whitePawn,
        e2: Piece.whitePawn,
        f2: Piece.whitePawn,
        g2: Piece.whitePawn,
        h2: Piece.whitePawn,
        
        a7: Piece.blackPawn,
        b7: Piece.blackPawn,
        c7: Piece.blackPawn,
        d7: Piece.blackPawn,
        e7: Piece.blackPawn,
        f7: Piece.blackPawn,
        g7: Piece.blackPawn,
        h7: Piece.blackPawn,
        
        a8: Piece.blackRook,
        b8: Piece.blackKnight,
        c8: Piece.blackBishop,
        d8: Piece.blackQueen,
        e8: Piece.blackKing,
        f8: Piece.blackBishop,
        g8: Piece.blackKnight,
        h8: Piece.blackRook
    ]

}
