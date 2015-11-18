//
//  History.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

class History {
    private var history: [Move] = []
    
    func append(move: Move) {
        history.append(move)
    }
}

// MARK: CustomStringConvertible

extension History: CustomStringConvertible {
    var description: String {
        get {
            var response: String = ""
            for index in 0..<history.count {
                if (index % 2 == 0) {
                    response += "\(1 + index / 2). \(history[index].start)\(history[index].end) "
                } else {
                    response += "\(history[index].start)\(history[index].end) "
                }
            }
            return response
        }
    }
}
