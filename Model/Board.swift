//
//  Board.swift
//  ChessMaster
//
//  Created by Regan Sarwas on 11/27/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

struct Board {
    fileprivate let pieces: [Location: Piece]
    let activeColor: Color
    let castlingOptions: CastlingOptions
    let enPassantTargetSquare: Location?
    let halfMoveClock: Int
    let fullMoveNumber: Int

    // MARK: - Initializers
    
    init(pieces: [Location: Piece],
        activeColor: Color,
        castlingOptions: CastlingOptions,
        enPassantTargetSquare: Location?,
        halfMoveClock: Int,
        fullMoveNumber: Int
        ) {
            self.pieces = pieces
            self.activeColor = activeColor
            self.castlingOptions = castlingOptions
            self.enPassantTargetSquare = enPassantTargetSquare
            self.halfMoveClock = halfMoveClock
            self.fullMoveNumber = fullMoveNumber
    }

    init() {
        self.init(pieces: Rules.defaultStartingBoard,
            activeColor: Color.white,
            castlingOptions: CastlingOptions.All,
            enPassantTargetSquare: nil,
            halfMoveClock: 0,
            fullMoveNumber: 1
        )
    }

    init?(fromFEN fen: String) {
        if let board = fen.fenBoard {
            self.pieces = board.pieces
            self.activeColor = board.activeColor
            self.castlingOptions = board.castlingOptions
            self.enPassantTargetSquare = board.enPassantTargetSquare
            self.halfMoveClock = board.halfMoveClock
            self.fullMoveNumber = board.fullMoveNumber
        } else {
            return nil
        }
    }


    // MARK: - Board Status Properties

    var inActiveColor: Color {
        return activeColor == .white ? .black : .white
    }

    var isActiveColorInCheck: Bool {
        return Rules.isActivePlayerInCheck(self)
    }

    var activeColorHasMoves: Bool {
        return Rules.doesActivePlayerHaveMoves(self)
    }

    // MARK: - Board Status Methods

    func pieceAt(_ location: Location) -> Piece? {
        return pieces[location]
    }

    func isEmptyAt(_ location: Location) -> Bool {
        return pieces[location] == nil
    }

    func locationsOfPiecesOfColor(_ color: Color) -> [Location] {
        return (pieces.filter{$0.1.color == color}).map{$0.0}
    }

    // returns true if the player with color is in check
    func locationOfKing(_ color: Color) -> Location? {
        let king = Piece(color: color, kind: .king)
        for (location, piece) in pieces {
            if piece == king {
                return location
            }
        }
        // Compiler should complain, logically we could return without a Location,
        // but that would be an invalid chess board
        return nil // by laws of chess this should never happen; required for type safety
    }

    // MARK: - Move Methods

    func makeMove(_ move: Move, promotionKind: Kind = .queen) -> (Board, Piece?)? {
        if Rules.validMoves(self, start: move.start).contains(move.end) {
            return makeMoveWithoutValidation(move, promotionKind: promotionKind)
        } else {
            return nil
        }
    }

    // We need this public method to avoid an infinite loop when checking valid moves
    // It is also faster if we know that a move is valid
    func makeMoveWithoutValidation(_ move: Move, promotionKind: Kind = .queen) -> (Board, Piece?)? {
        // Save some state at beginning of move
        if let movingPiece = self.pieceAt(move.start) {
            let newEnPassantTargetSquare = Rules.enPassantTargetSquare(self, move: move)
            let castelingRookMove = Rules.rookMoveWhileCastling(self, move: move)
            let promotionPiece = Rules.promotionPiece(self, move: move, promotionKind: promotionKind)
            let resetHalfMoveClock = Rules.resetHalfMoveClock(self, move: move)

            // Update State of pieces
            var newPieces = pieces
            var lastCapturedPiece: Piece? = nil
            if let enPassantCaptureSquare = Rules.enPassantCaptureSquare(self, move: move) {
                lastCapturedPiece = pieces[enPassantCaptureSquare]
                newPieces[enPassantCaptureSquare] = nil
            }
            if lastCapturedPiece == nil {
                lastCapturedPiece = pieces[move.end]
            }
            newPieces[move.end] = promotionPiece == nil ? movingPiece: promotionPiece
            newPieces[move.start] = nil
            if castelingRookMove != nil {
                newPieces[castelingRookMove!.end] = pieces[castelingRookMove!.start]!
                newPieces[castelingRookMove!.start] = nil
            }

            let newBoard = Board(
                pieces: newPieces,
                activeColor: self.inActiveColor,
                castlingOptions: Rules.newCastlingOptions(self.castlingOptions, location: move.start),
                enPassantTargetSquare: newEnPassantTargetSquare,
                halfMoveClock: resetHalfMoveClock ? 0 : self.halfMoveClock + 1,
                fullMoveNumber: self.fullMoveNumber + (self.activeColor == .black ? 1 : 0)
            )
            return (newBoard, lastCapturedPiece)
        }
        return nil
    }
}

// MARK: - Extensions: Equatable, SequenceType

extension Board: Equatable {}

func == (lhs: Board, rhs: Board) -> Bool {
    return lhs.pieces == rhs.pieces &&
        lhs.activeColor == rhs.activeColor &&
        lhs.castlingOptions == rhs.castlingOptions &&
        lhs.enPassantTargetSquare == rhs.enPassantTargetSquare
    // Move counts are not used in equality; because we only care Rules 9.2 and 9.3
}

extension Board: Sequence {
    typealias Iterator = DictionaryGenerator<Location,Piece>
    
    func makeIterator() -> Iterator {
        return pieces.makeIterator()
    }
}
