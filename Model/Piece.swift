//
//  Piece.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

enum Kind {
    case King, Queen, Rook, Bishop, Knight, Pawn
}

enum Color {
    case White, Black
}

struct Piece: Equatable {
    let color: Color
    let kind: Kind
}

// MARK: Hashable

extension Piece: Hashable {
    var hashValue: Int {
        return kind.hashValue ^ kind.hashValue
    }
}

// MARK: Equatable

func == (left:Piece, right:Piece) -> Bool {
    return (left.kind == right.kind)  && (left.color == right.color)
}

// MARK: CustomStringConvertible

extension Piece: CustomStringConvertible {
    var pgn: String {
        get {
            switch kind {
            case .King: return "K";
            case .Queen: return "Q";
            case .Rook: return "R";
            case .Bishop: return "B";
            case .Knight: return "N";
            case .Pawn: return "";
            }
        }
    }
    var fen: String {
        get {
            switch color {
            case .White:
                switch kind {
                case .King: return "K";
                case .Queen: return "Q";
                case .Rook: return "R";
                case .Bishop: return "B";
                case .Knight: return "N";
                case .Pawn: return "P";
                }
            case .Black:
                switch kind {
                case .King: return "k";
                case .Queen: return "q";
                case .Rook: return "r";
                case .Bishop: return "b";
                case .Knight: return "n";
                case .Pawn: return "p";
                }
            }
        }
    }
    var description: String {
        get {
            switch color {
            case .White:
                switch kind {
                case .King: return "♔";
                case .Queen: return "♕";
                case .Rook: return "♖";
                case .Bishop: return "♗";
                case .Knight: return "♘";
                case .Pawn: return "♙";
                }
            case .Black:
                switch kind {
                case .King: return "♚";
                case .Queen: return "♛";
                case .Rook: return "♜";
                case .Bishop: return "♝";
                case .Knight: return "♞";
                case .Pawn: return "♟";
                }
            }
        }
    }
}

extension Character {
    var fenPiece: Piece? {
        switch self {
        case "K": return Piece(color: .White, kind: .King)
        case "Q": return Piece(color: .White, kind: .Queen)
        case "R": return Piece(color: .White, kind: .Rook)
        case "B": return Piece(color: .White, kind: .Bishop)
        case "N": return Piece(color: .White, kind: .Knight)
        case "P": return Piece(color: .White, kind: .Pawn)
        case "k": return Piece(color: .Black, kind: .King)
        case "q": return Piece(color: .Black, kind: .Queen)
        case "r": return Piece(color: .Black, kind: .Rook)
        case "b": return Piece(color: .Black, kind: .Bishop)
        case "n": return Piece(color: .Black, kind: .Knight)
        case "p": return Piece(color: .Black, kind: .Pawn)
        default:
            print("FEN Piece '\(self)' is not recognized.")
            return nil
        }
    }
}

