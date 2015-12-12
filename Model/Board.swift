//
//  Board.swift
//  ChessMaster
//
//  Created by Regan Sarwas on 11/27/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

struct Board {
    private let pieces: [Location: Piece]
    let activeColor: Color
    let castlingOptions: CastlingOptions
    let enPassantTargetSquare: Location?
    let halfMoveClock: Int
    let fullMoveNumber: Int

    //MARK: - Initializers
    
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
            activeColor: Color.White,
            castlingOptions: CastlingOptions.All,
            enPassantTargetSquare: nil,
            halfMoveClock: 0,
            fullMoveNumber: 1
        )
    }

    //MARK: - Board Status Properties

    var inActiveColor : Color {
        return activeColor == .White ? .Black : .White
    }

    var isActiveColorInCheck: Bool {
        return Rules.isActivePlayerInCheck(self)
    }

    var activeColorHasMoves: Bool {
        return Rules.doesActivePlayerHaveMoves(self)
    }

    //MARK: - Board Status Methods

    func pieceAt(location:Location) -> Piece? {
        return pieces[location]
    }

    func isEmptyAt(location:Location) -> Bool {
        return pieces[location] == nil
    }

    func locationsOfPiecesOfColor(color: Color) -> [Location] {
        return (pieces.filter{$0.1.color == color}).map{$0.0}
    }

    //returns true if the player with color is in check
    func locationOfKing(color: Color) -> Location? {
        let king = Piece(color:color, kind: .King)
        for (location,piece) in pieces {
            if piece == king {
                return location
            }
        }
        // Compiler should complain, logically we could return without a Location,
        // but that would be an invalid chess board
        return nil // by laws of chess this should never happen; required for type safety
    }

    //MARK: - Move Methods

    func makeMove(move:Move, promotionKind:Kind = .Queen) -> (Board, Piece?)? {
        if Rules.validMoves(self, start:move.start).contains(move.end) {
            return makeMoveWithoutValidation(move, promotionKind:promotionKind)
        } else {
            return nil
        }
    }

    // We need this public method to avoid an infinite loop when checking valid moves
    // It is also faster if we know that a move is valid
    func makeMoveWithoutValidation(move:Move, promotionKind:Kind = .Queen) -> (Board, Piece?)? {
        // Save some state at beginning of move
        if let movingPiece = self.pieceAt(move.start) {
            let newEnPassantTargetSquare = Rules.enPassantTargetSquare(self, move:move)
            let castelingRookMove = Rules.rookMoveWhileCastling(self, move: move)
            let promotionPiece = Rules.promotionPiece(self, move: move, promotionKind: promotionKind)
            let resetHalfMoveClock = Rules.resetHalfMoveClock(self, move: move)

            // Update State of pieces
            var newPieces = pieces
            var lastCapturedPiece: Piece? = nil
            if let enPassantCaptureSquare = Rules.enPassantCaptureSquare(self, move:move) {
                lastCapturedPiece = pieces[enPassantCaptureSquare]
                newPieces[enPassantCaptureSquare] = nil
            }
            if lastCapturedPiece == nil {
                lastCapturedPiece = pieces[move.end]
            }
            newPieces[move.end] = promotionPiece == nil ? movingPiece : promotionPiece
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
                fullMoveNumber: self.fullMoveNumber + (self.activeColor == .Black ? 1 : 0)
            )
            return (newBoard, lastCapturedPiece)
        }
        return nil
    }
}

//MARK: - Extensions: Equatable, SequenceType

extension Board : Equatable {}

func == (lhs:Board, rhs:Board) -> Bool {
    return lhs.pieces == rhs.pieces &&
        lhs.activeColor == rhs.activeColor &&
        lhs.castlingOptions == rhs.castlingOptions &&
        lhs.enPassantTargetSquare == rhs.enPassantTargetSquare
    //Move counts are not used in equality; because we only care Rules 9.2 and 9.3
}

extension Board : SequenceType {
    typealias Generator = DictionaryGenerator<Location,Piece>
    
    func generate() -> Generator {
        return pieces.generate()
    }
}