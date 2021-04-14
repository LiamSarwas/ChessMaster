//
//  Board_IO.swift
//  ChessMaster
//
//  Created by Regan Sarwas on 11/3/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

// MARK: - CustomStringConvertible

// Forsyth–Edwards Notation (FEN) is a standard notation for describing a board position in Chess
// https://en.wikipedia.org/wiki/Forsyth–Edwards_Notation
// It is an ASCII character string composed of 6 required parts separated by a space
// for additional details see section 16.1 at http://www.thechessdrum.net/PGN_Reference.txt

extension Board: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        return fen
    }
    
    var debugDescription: String {
        return fen
    }

    var fenBoard: String {
        var lines: [String] = []
        for rank in Rank.allReverseValues {
            var line = ""
            var emptyCount = 0
            for file in File.allForwardValues {
                if let piece = pieceAt(Location(file: file, rank: rank)) {
                    if 0 < emptyCount {
                        line += "\(emptyCount)"
                        emptyCount = 0
                    }
                    line += "\(piece.fen)"
                } else {
                    emptyCount += 1
                }
            }
            if emptyCount > 0 {
                line += "\(emptyCount)"
            }
            lines.append(line)
        }
        return lines.joined(separator: "/")
    }

    var fen: String {
        get {            
            let enPassant = enPassantTargetSquare == nil ? "-" : "\(enPassantTargetSquare!)"
            let color = activeColor == .white ? "w" : "b"
            let castle =
                (castlingOptions.contains(.whiteKingSide) ? "K" : "") +
                (castlingOptions.contains(.whiteQueenSide) ? "Q" : "") +
                (castlingOptions.contains(.blackQueenSide) ? "k" : "") +
                (castlingOptions.contains(.blackQueenSide) ? "q" : "") +
                (castlingOptions == .none ? "-" : "")
            return "\(fenBoard) \(color) \(castle) \(enPassant) \(halfMoveClock) \(fullMoveNumber)"
        }
    }
}

// MARK: - Input

extension String {
    var fenBoard: Board? {
        let parts = self.split(separator: " ")
        if parts.count != 6 {
            print("FEN line '\(self)' does not have 6 parts")
            return nil
        }
        if let piecePlacement = parseFenPiecePlacement(String(parts[0])) {
            if let activeColor = parseFenActiveColor(String(parts[1])) {
                if let castlingOptions = parseFenCastlingOptions(String(parts[2])) {
                    let (ok, enPassant) = parseFenEnPassantTargetSquare(String(parts[3]))
                    if ok {
                        if let halfMoveClock = parseFenHalfMoveClock(String(parts[4])) {
                            if let fullMoveNumber = parseFenFullMoveNumber(String(parts[5])) {
                                return Board(pieces: piecePlacement,
                                    activeColor: activeColor,
                                    castlingOptions: castlingOptions,
                                    enPassantTargetSquare: enPassant,
                                    halfMoveClock: halfMoveClock,
                                    fullMoveNumber: fullMoveNumber)
                            }
                        }
                    }
                }
            }
        }
        return nil
    }
    
    func parseFenPiecePlacement(_ s: String) -> [Location: Piece]? {
        let ranks = s.split(separator: "/")
        if ranks.count != 8 {
            print("FEN line '\(s)' does not have 8 ranks")
            return nil
        }
        var board = Dictionary<Location,Piece>()
        for index in 0...7 {
            if let rank_list = parseFenRank(String(ranks[index])) {
                let rank = Rank(8 - index)!
                for (i,file) in File.allForwardValues.enumerated() {
                    board[Location(file: file, rank: rank)] = rank_list[i]
                }
            } else {
                return nil
            }
        }
        return board
    }
    func parseFenActiveColor(_ s: String) -> Color? {
        if s == "w" { return .white }
        if s == "b" { return .black }
        print("FEN Active Color '\(s)' is not 'w' or 'b'")
        return nil
    }
    
    func parseFenCastlingOptions(_ str: String) -> CastlingOptions? {
        var s = str
        var castlingOptions = CastlingOptions.none
        if s == "-" { return castlingOptions }
        if s.hasPrefix("K") {
            castlingOptions.insert(.whiteKingSide)
            s.remove(at: s.startIndex)
        }
        if s.hasPrefix("Q") {
            castlingOptions.insert(.whiteQueenSide)
            s.remove(at: s.startIndex)
        }
        if s.hasPrefix("k") {
            castlingOptions.insert(.blackKingSide)
            s.remove(at: s.startIndex)
        }
        if s.hasPrefix("q") {
            castlingOptions.insert(.blackQueenSide)
            s.remove(at: s.startIndex)
        }
        if s.count == 0 {
            return castlingOptions
        } else {
            print("FEN Castle Availability '\(str)' has unexpected characters or order")
        }
        return nil
    }
    
    func parseFenEnPassantTargetSquare(_ s: String) -> (Bool, Location?) {
        if s == "-" { return (true, nil) }
        if let location = Location(s) {
            if location.rank == Rank.r3 || location.rank == Rank.r6 {
                return (true, location)
            } else {
                print("FEN enPassant target square '\(s)' is not on rank 3 or 6")
            }
        } else {
            print("FEN enPassant target square '\(s)' is not a valid board position")
        }
        return (false, nil)
    }
    
    func parseFenHalfMoveClock(_ s: String) -> Int? {
        if let count = Int(s) {
            if 0 <= count {
                return count
            } else {
                print("FEN Halfmove Clock '\(s)' is not non-negative")
            }
        } else {
            print("FEN Halfmove Clock '\(s)' is not an integer")
        }
        return nil
    }
    
    func parseFenFullMoveNumber(_ s: String) -> Int? {
        if let count = Int(s) {
            if 0 < count {
                return count
            } else {
                print("FEN Fullmove Number '\(s)' is not positive")
            }
        } else {
            print("FEN Fullmove Number '\(s)' is not an integer")
        }
        return nil
    }
    func parseFenRank(_ str: String) -> [Piece?]? {
        let s = expandBlanks(str)
        if s.count == 8 {
            // FIXME: Check for unrecognized pieces
            return s.map { $0 == "-" ? nil : $0.fenPiece }
        } else {
            print("FEN FenRank '\(str)' does not have 8 squares")
        }
        return nil
    }
    func expandBlanks(_ str: String) -> String {
        var s = ""
        for c in str {
            switch c {
            case "8": s += "--------"
            case "7": s += "-------"
            case "6": s += "------"
            case "5": s += "-----"
            case "4": s += "----"
            case "3": s += "---"
            case "2": s += "--"
            case "1": s += "-"
            default: s += String(c)
            }
        }
        return s
    }
}
