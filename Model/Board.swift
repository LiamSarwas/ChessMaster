//
//  Board.swift
//  ChessMaster
//
//  Created by Regan Sarwas on 11/28/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

typealias Board = [Location: Piece]

//TODO:  Make this global function an extension to Board (if possible)
func fenDescription(board:Board) -> String {
    var lines :[String] = []
    for rank in Rank.allValues.reverse() {
        var line = ""
        var emptyCount = 0
        for file in File.allValues {
            if let piece = board[Location(rank:rank, file:file)] {
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
