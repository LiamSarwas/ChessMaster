//
//  Piece.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

enum Kind {
    case king, queen, rook, bishop, knight, pawn
}

enum Color {
    case white, black
}

struct Piece: Equatable {
    let color: Color
    let kind: Kind

    // static pieces for easy reference
    static let whiteKing   = Piece(color: .white, kind: .king)
    static let whiteQueen  = Piece(color: .white, kind: .queen)
    static let whiteRook   = Piece(color: .white, kind: .rook)
    static let whiteBishop = Piece(color: .white, kind: .bishop)
    static let whiteKnight = Piece(color: .white, kind: .knight)
    static let whitePawn   = Piece(color: .white, kind: .pawn)
    static let blackKing   = Piece(color: .black, kind: .king)
    static let blackQueen  = Piece(color: .black, kind: .queen)
    static let blackRook   = Piece(color: .black, kind: .rook)
    static let blackBishop = Piece(color: .black, kind: .bishop)
    static let blackKnight = Piece(color: .black, kind: .knight)
    static let blackPawn   = Piece(color: .black, kind: .pawn)
}

// MARK: - Hashable

extension Piece: Hashable {
    var hashValue: Int {
        return kind.hashValue ^ color.hashValue
    }
}

// MARK: - Equatable

func == (left: Piece, right: Piece) -> Bool {
    return (left.kind == right.kind)  && (left.color == right.color)
}

// MARK: - CustomStringConvertible

extension Piece: CustomStringConvertible {
    var pgn: String {
        get {
            switch kind {
            case .king: return "K";
            case .queen: return "Q";
            case .rook: return "R";
            case .bishop: return "B";
            case .knight: return "N";
            case .pawn: return "";
            }
        }
    }
    var fen: String {
        get {
            switch color {
            case .white:
                switch kind {
                case .king: return "K";
                case .queen: return "Q";
                case .rook: return "R";
                case .bishop: return "B";
                case .knight: return "N";
                case .pawn: return "P";
                }
            case .black:
                switch kind {
                case .king: return "k";
                case .queen: return "q";
                case .rook: return "r";
                case .bishop: return "b";
                case .knight: return "n";
                case .pawn: return "p";
                }
            }
        }
    }
    var description: String {
        get {
            switch color {
            case .white:
                switch kind {
                case .king: return "♔";
                case .queen: return "♕";
                case .rook: return "♖";
                case .bishop: return "♗";
                case .knight: return "♘";
                case .pawn: return "♙";
                }
            case .black:
                switch kind {
                case .king: return "♚";
                case .queen: return "♛";
                case .rook: return "♜";
                case .bishop: return "♝";
                case .knight: return "♞";
                case .pawn: return "♟";
                }
            }
        }
    }
}

extension Character {
    var fenPiece: Piece? {
        switch self {
        case "K": return Piece(color: .white, kind: .king)
        case "Q": return Piece(color: .white, kind: .queen)
        case "R": return Piece(color: .white, kind: .rook)
        case "B": return Piece(color: .white, kind: .bishop)
        case "N": return Piece(color: .white, kind: .knight)
        case "P": return Piece(color: .white, kind: .pawn)
        case "k": return Piece(color: .black, kind: .king)
        case "q": return Piece(color: .black, kind: .queen)
        case "r": return Piece(color: .black, kind: .rook)
        case "b": return Piece(color: .black, kind: .bishop)
        case "n": return Piece(color: .black, kind: .knight)
        case "p": return Piece(color: .black, kind: .pawn)
        default:
            print("FEN Piece '\(self)' is not recognized.")
            return nil
        }
    }
}

