//
//  History.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

typealias History = [(board:Board,move:Move)]

//TODO:  Make this global function an extension to History (if possible)
func PGNstring(history:History) -> String
{
    var response: String = ""
    for index in 0..<history.count {
        //TODO: Implement the PGN Protocol
        if (index % 2 == 0) {
            response += "\(1 + index / 2). \(history[index].move.start)\(history[index].move.end) "
        } else {
            response += "\(history[index].move.start)\(history[index].move.end) "
        }
    }
    return response
}
