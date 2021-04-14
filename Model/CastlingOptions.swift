//
//  CastlingOptions.swift
//  ChessMaster
//
//  Created by Regan Sarwas on 11/26/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

struct CastlingOptions: OptionSet {
    let rawValue: Int

    static let none  = CastlingOptions([])
    static let whiteKingSide  = CastlingOptions(rawValue:1)
    static let whiteQueenSide  = CastlingOptions(rawValue:2)
    static let blackKingSide = CastlingOptions(rawValue:4)
    static let blackQueenSide = CastlingOptions(rawValue:8)
    static let bothWhite: CastlingOptions = [.whiteKingSide, .whiteQueenSide]
    static let bothBlack: CastlingOptions = [.blackKingSide, .blackQueenSide]
    static let all: CastlingOptions = [.bothWhite, .bothBlack]
}
