//
//  Game_io.swift
//  Chess_cmd
//
//  Created by Regan Sarwas on 11/3/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

// MARK: CustomStringConvertible

extension Game: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        get {
            return description_FEN
        }
    }
    
    var debugDescription: String {
        get {
            return description_FEN
        }
    }
    
    var description_FEN: String {
        get {
            var fenGame: String {
                get {
                    var lines :[String] = []
                    for rank in [8,7,6,5,4,3,2,1] {
                        var line = ""
                        var emptyCount = 0
                        for file in [File.A, .B, .C, .D, .E, .F, .G, .H] {
                            if let piece = board[Location(rank:Rank(integerLiteral:rank), file:file)] {
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
                    return lines.joinWithSeparator("/")
                }
            }
            let enPassant = enPassantTargetSquare == nil ? "-" : "\(enPassantTargetSquare!)"
            let castle = (whiteHasKingSideCastleAvailable ? "K" : "") +
                (whiteHasQueenSideCastleAvailable ? "Q" : "") +
                (blackHasKingSideCastleAvailable ? "k" : "") +
                (blackHasQueenSideCastleAvailable ? "q" : "") +
                (whiteHasKingSideCastleAvailable ||
                    whiteHasQueenSideCastleAvailable ||
                    blackHasKingSideCastleAvailable ||
                    blackHasQueenSideCastleAvailable ? "" : "-")
            let color = activeColor == .White ? "w" : "b"
            return "\(fenGame) \(color) \(castle) \(enPassant) \(halfMoveClock) \(fullMoveNumber)"
        }
    }
}

extension String {
    var fenGame: Game? {
        //a fen Game description is composed of 6 required parts separated by a space
        let parts = self.split(" ")
        if parts.count != 6 {
            print("FEN line '\(self)' does not have 6 parts")
            return nil
        }
        if let piecePlacement = parseFenPiecePlacement(parts[0]) {
            if let activeColor = parseFenActiveColor(parts[1]) {
                if let (wk,wq,bk,bq) = parseFenCastlingAvailability(parts[2]) {
                    let (ok, enPassant) = parseFenEnPassantTargetSquare(parts[3])
                    if ok {
                        if let halfMoveClock = parseFenHalfMoveClock(parts[4]) {
                            if let fullMoveNumber = parseFenFullMoveNumber(parts[5]) {
                                return Game(board: piecePlacement,
                                    activeColor: activeColor,
                                    whiteHasKingSideCastleAvailable: wk,
                                    whiteHasQueenSideCastleAvailable: wq,
                                    blackHasKingSideCastleAvailable: bk,
                                    blackHasQueenSideCastleAvailable: bq,
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
    
    func parseFenPiecePlacement(s:String) -> [Location:Piece]? {
        let ranks = s.split("/")
        if ranks.count != 8 {
            print("FEN line '\(s)' does not have 8 ranks")
            return nil
        }
        var board = Dictionary<Location,Piece>()
        for index in 0...7 {
            if let rank_list = parseFenRank(ranks[index]) {
                let rank = 8 - index
                for (i,file) in [File.A, .B, .C, .D, .E, .F, .G, .H].enumerate() {
                    board[Location(rank:Rank(integerLiteral:rank), file: file)] = rank_list[i]
                }
            } else {
                return nil
            }
        }
        return board
    }
    func parseFenActiveColor(s:String) -> Color? {
        if s == "w" { return .White }
        if s == "b" { return .Black }
        print("FEN Active Color '\(s)' is not 'w' or 'b'")
        return nil
    }
    
    func parseFenCastlingAvailability(str:String) -> (Bool, Bool, Bool, Bool)? {
        var s = str
        if s == "-" { return (false, false, false, false) }
        var (wk, wq, bk, bq) = (false, false, false, false)
        if s.hasPrefix("K") {
            wk = true
            s.removeAtIndex(s.startIndex)
        }
        if s.hasPrefix("Q") {
            wq = true
            s.removeAtIndex(s.startIndex)
        }
        if s.hasPrefix("k") {
            bk = true
            s.removeAtIndex(s.startIndex)
        }
        if s.hasPrefix("q") {
            bq = true
            s.removeAtIndex(s.startIndex)
        }
        if s.characters.count == 0 {
            return (wk, wq, bk, bq)
        } else {
            print("FEN Castle Availability '\(str)' has unexpected characters or order")
        }
        return nil
    }
    
    func parseFenEnPassantTargetSquare(s:String) -> (Bool, Location?) {
        if s == "-" { return (true, nil) }
        if let location = s.fenLocation {
            if location.rank == 3 || location.rank == 6 {
                return (true, location)
            } else {
                print("FEN enPassant target square '\(s)' is not on rank 3 or 6")
            }
        } else {
            print("FEN enPassant target square '\(s)' is not a valid board position")
        }
        return (false, nil)
    }
    
    func parseFenHalfMoveClock(s:String) -> Int? {
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
    
    func parseFenFullMoveNumber(s:String) -> Int? {
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
    func parseFenRank(str:String) -> [Piece?]? {
        let s = expandBlanks(str)
        if s.characters.count == 8 {
            //FIXME: Check for unrecognized pieces
            return s.characters.map { $0 == "-" ? nil : $0.fenPiece }
        } else {
            print("FEN FenRank '\(str)' does not have 8 squares")
        }
        return nil
    }
    func expandBlanks(str:String) -> String {
        var s = ""
        for c in str.characters {
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





