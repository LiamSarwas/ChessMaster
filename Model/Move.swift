//
//  Move.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

typealias Move = (start:Location, end:Location)

// MARK: Equatable

func == (left:Move, right:Move) -> Bool {
    return (left.start == right.start) && (left.end == right.end)
}
