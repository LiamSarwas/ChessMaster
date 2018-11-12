//
//  Location.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

// MARK: - Global locations to make code easier to read

// static locations for easy reference
let a1 = Location(file: .a, rank: .r1)
let b1 = Location(file: .b, rank: .r1)
let c1 = Location(file: .c, rank: .r1)
let d1 = Location(file: .d, rank: .r1)
let e1 = Location(file: .e, rank: .r1)
let f1 = Location(file: .f, rank: .r1)
let g1 = Location(file: .g, rank: .r1)
let h1 = Location(file: .h, rank: .r1)

let a2 = Location(file: .a, rank: .r2)
let b2 = Location(file: .b, rank: .r2)
let c2 = Location(file: .c, rank: .r2)
let d2 = Location(file: .d, rank: .r2)
let e2 = Location(file: .e, rank: .r2)
let f2 = Location(file: .f, rank: .r2)
let g2 = Location(file: .g, rank: .r2)
let h2 = Location(file: .h, rank: .r2)

let a3 = Location(file: .a, rank: .r3)
let b3 = Location(file: .b, rank: .r3)
let c3 = Location(file: .c, rank: .r3)
let d3 = Location(file: .d, rank: .r3)
let e3 = Location(file: .e, rank: .r3)
let f3 = Location(file: .f, rank: .r3)
let g3 = Location(file: .g, rank: .r3)
let h3 = Location(file: .h, rank: .r3)

let a4 = Location(file: .a, rank: .r4)
let b4 = Location(file: .b, rank: .r4)
let c4 = Location(file: .c, rank: .r4)
let d4 = Location(file: .d, rank: .r4)
let e4 = Location(file: .e, rank: .r4)
let f4 = Location(file: .f, rank: .r4)
let g4 = Location(file: .g, rank: .r4)
let h4 = Location(file: .h, rank: .r4)

let a5 = Location(file: .a, rank: .r5)
let b5 = Location(file: .b, rank: .r5)
let c5 = Location(file: .c, rank: .r5)
let d5 = Location(file: .d, rank: .r5)
let e5 = Location(file: .e, rank: .r5)
let f5 = Location(file: .f, rank: .r5)
let g5 = Location(file: .g, rank: .r5)
let h5 = Location(file: .h, rank: .r5)

let a6 = Location(file: .a, rank: .r6)
let b6 = Location(file: .b, rank: .r6)
let c6 = Location(file: .c, rank: .r6)
let d6 = Location(file: .d, rank: .r6)
let e6 = Location(file: .e, rank: .r6)
let f6 = Location(file: .f, rank: .r6)
let g6 = Location(file: .g, rank: .r6)
let h6 = Location(file: .h, rank: .r6)

let a7 = Location(file: .a, rank: .r7)
let b7 = Location(file: .b, rank: .r7)
let c7 = Location(file: .c, rank: .r7)
let d7 = Location(file: .d, rank: .r7)
let e7 = Location(file: .e, rank: .r7)
let f7 = Location(file: .f, rank: .r7)
let g7 = Location(file: .g, rank: .r7)
let h7 = Location(file: .h, rank: .r7)

let a8 = Location(file: .a, rank: .r8)
let b8 = Location(file: .b, rank: .r8)
let c8 = Location(file: .c, rank: .r8)
let d8 = Location(file: .d, rank: .r8)
let e8 = Location(file: .e, rank: .r8)
let f8 = Location(file: .f, rank: .r8)
let g8 = Location(file: .g, rank: .r8)
let h8 = Location(file: .h, rank: .r8)

// MARK: - Location

public struct Location {
    let file: File
    let rank: Rank
}

// MARK: - Equatable

extension Location: Equatable {}

public func == (left: Location, right: Location) -> Bool {
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
        if value.count != 2 { return nil }
        let file = File(value[value.startIndex])
        if file == nil { return nil }
        let rank = Rank(value[value.index(after: value.startIndex)])
        if rank == nil { return nil }
        self.file = file!
        self.rank = rank!
    }
}
