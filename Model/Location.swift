//
//  Location.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

// MARK: - Global locations to make code easier to read

//static locations for easy reference
let a1 = Location(file: .A, rank: .R1)
let b1 = Location(file: .B, rank: .R1)
let c1 = Location(file: .C, rank: .R1)
let d1 = Location(file: .D, rank: .R1)
let e1 = Location(file: .E, rank: .R1)
let f1 = Location(file: .F, rank: .R1)
let g1 = Location(file: .G, rank: .R1)
let h1 = Location(file: .H, rank: .R1)

let a2 = Location(file: .A, rank: .R2)
let b2 = Location(file: .B, rank: .R2)
let c2 = Location(file: .C, rank: .R2)
let d2 = Location(file: .D, rank: .R2)
let e2 = Location(file: .E, rank: .R2)
let f2 = Location(file: .F, rank: .R2)
let g2 = Location(file: .G, rank: .R2)
let h2 = Location(file: .H, rank: .R2)

let a3 = Location(file: .A, rank: .R3)
let b3 = Location(file: .B, rank: .R3)
let c3 = Location(file: .C, rank: .R3)
let d3 = Location(file: .D, rank: .R3)
let e3 = Location(file: .E, rank: .R3)
let f3 = Location(file: .F, rank: .R3)
let g3 = Location(file: .G, rank: .R3)
let h3 = Location(file: .H, rank: .R3)

let a4 = Location(file: .A, rank: .R4)
let b4 = Location(file: .B, rank: .R4)
let c4 = Location(file: .C, rank: .R4)
let d4 = Location(file: .D, rank: .R4)
let e4 = Location(file: .E, rank: .R4)
let f4 = Location(file: .F, rank: .R4)
let g4 = Location(file: .G, rank: .R4)
let h4 = Location(file: .H, rank: .R4)

let a5 = Location(file: .A, rank: .R5)
let b5 = Location(file: .B, rank: .R5)
let c5 = Location(file: .C, rank: .R5)
let d5 = Location(file: .D, rank: .R5)
let e5 = Location(file: .E, rank: .R5)
let f5 = Location(file: .F, rank: .R5)
let g5 = Location(file: .G, rank: .R5)
let h5 = Location(file: .H, rank: .R5)

let a6 = Location(file: .A, rank: .R6)
let b6 = Location(file: .B, rank: .R6)
let c6 = Location(file: .C, rank: .R6)
let d6 = Location(file: .D, rank: .R6)
let e6 = Location(file: .E, rank: .R6)
let f6 = Location(file: .F, rank: .R6)
let g6 = Location(file: .G, rank: .R6)
let h6 = Location(file: .H, rank: .R6)

let a7 = Location(file: .A, rank: .R7)
let b7 = Location(file: .B, rank: .R7)
let c7 = Location(file: .C, rank: .R7)
let d7 = Location(file: .D, rank: .R7)
let e7 = Location(file: .E, rank: .R7)
let f7 = Location(file: .F, rank: .R7)
let g7 = Location(file: .G, rank: .R7)
let h7 = Location(file: .H, rank: .R7)

let a8 = Location(file: .A, rank: .R8)
let b8 = Location(file: .B, rank: .R8)
let c8 = Location(file: .C, rank: .R8)
let d8 = Location(file: .D, rank: .R8)
let e8 = Location(file: .E, rank: .R8)
let f8 = Location(file: .F, rank: .R8)
let g8 = Location(file: .G, rank: .R8)
let h8 = Location(file: .H, rank: .R8)

// MARK: - Location

public struct Location {
    let file: File
    let rank: Rank
}

// MARK: - Equatable

extension Location: Equatable {}

public func == (left:Location, right:Location) -> Bool {
    return (left.rank == right.rank)  && (left.file == right.file)
}

// MARK: - Hashable

extension Location: Hashable {
    public var hashValue: Int {
        return rank.hashValue ^ file.hashValue
    }
}

// MARK: - CustomStringConvertible

extension Location: CustomStringConvertible {
    public var description: String {
        get { return "\(file)\(rank)" }
    }
}

// MARK: - Failable initializer from string

extension Location {
    init?(_ value: String) {
        if value.characters.count != 2 { return nil }
        let file = File(value[value.startIndex])
        if file == nil { return nil }
        let rank = Rank(value[value.startIndex.successor()])
        if rank == nil { return nil }
        self.file = file!
        self.rank = rank!
    }
}
