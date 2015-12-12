//
//  Location.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

// MARK: Rank

public struct Rank : IntegerLiteralConvertible {
    let value: Int
    
    //FIXME:  Rank should be limited, and certain integerLiteral should cause exception
    public init(integerLiteral value: Int) {
        self.value = value
    }
    
    static let minValue: Rank = 1
    static let maxValue: Rank = 8
    static let allValues: [Rank] = [1,2,3,4,5,6,7,8]
    
    func toNorth() -> ArraySlice<Rank> {
        if self == Rank.maxValue {
            return []
        }
        return Rank.allValues[self.value...(Rank.maxValue.value - 1)]
    }
    func toSouth() -> [Rank] {
        if self == Rank.minValue {
            return []
        }
        return Array(Rank.allValues[0...(self.value - 2)]).reverse()
    }
}

func + (rank: Rank, n: Int) -> Rank? {
    let newValue = rank.value + n
    if newValue < Rank.minValue.value || Rank.maxValue.value < newValue {
        return nil
    }
    return Rank(integerLiteral: newValue)
}


// MARK: Rank - Hashable

extension Rank: Hashable {
    public var hashValue: Int {
        return value.hashValue
    }
}

// MARK: Rank - Equatable

public func == (left:Rank, right:Rank) -> Bool {
    return (left.value == right.value)
}

// MARK: Rank - Comparable

public func < (left:Rank, right:Rank) -> Bool {
    return (left.value < right.value)
}

// MARK: Rank - CustomStringConvertible

extension Rank: CustomStringConvertible {
    public var description: String {
        get { return "\(value)" }
    }
}


// MARK: File

public enum File: Int {
    case A = 1, B, C, D, E, F, G, H
    static let allValues = [File.A, .B, .C, .D, .E, .F, .G, .H]
    static let minValue = File.A
    static let maxValue = File.H
    func toEast() -> ArraySlice<File> {
        if self == .H {
            return []
        }
        return File.allValues[self.rawValue...(File.maxValue.rawValue - 1)]
    }
    func toWest() -> [File] {
        if self == .A {
            return []
        }
        return Array(File.allValues[0...(self.rawValue-2)]).reverse()
    }
}

func + (file: File, n: Int) -> File? {
    return File(rawValue: file.rawValue + n)
}


// MARK: File - CustomStringConvertible

extension File: CustomStringConvertible {
    public var description: String {
        get {
            switch self {
            case .A: return "a"
            case .B: return "b"
            case .C: return "c"
            case .D: return "d"
            case .E: return "e"
            case .F: return "f"
            case .G: return "g"
            case .H: return "h"
            }
        }
    }
}


// MARK: Location

// Global locations to make code easier to read

//static locations for easy reference
let a1 = Location(file: .A, rank: 1)
let b1 = Location(file: .B, rank: 1)
let c1 = Location(file: .C, rank: 1)
let d1 = Location(file: .D, rank: 1)
let e1 = Location(file: .E, rank: 1)
let f1 = Location(file: .F, rank: 1)
let g1 = Location(file: .G, rank: 1)
let h1 = Location(file: .H, rank: 1)

let a2 = Location(file: .A, rank: 2)
let b2 = Location(file: .B, rank: 2)
let c2 = Location(file: .C, rank: 2)
let d2 = Location(file: .D, rank: 2)
let e2 = Location(file: .E, rank: 2)
let f2 = Location(file: .F, rank: 2)
let g2 = Location(file: .G, rank: 2)
let h2 = Location(file: .H, rank: 2)

let a3 = Location(file: .A, rank: 3)
let b3 = Location(file: .B, rank: 3)
let c3 = Location(file: .C, rank: 3)
let d3 = Location(file: .D, rank: 3)
let e3 = Location(file: .E, rank: 3)
let f3 = Location(file: .F, rank: 3)
let g3 = Location(file: .G, rank: 3)
let h3 = Location(file: .H, rank: 3)

let a4 = Location(file: .A, rank: 4)
let b4 = Location(file: .B, rank: 4)
let c4 = Location(file: .C, rank: 4)
let d4 = Location(file: .D, rank: 4)
let e4 = Location(file: .E, rank: 4)
let f4 = Location(file: .F, rank: 4)
let g4 = Location(file: .G, rank: 4)
let h4 = Location(file: .H, rank: 4)

let a5 = Location(file: .A, rank: 5)
let b5 = Location(file: .B, rank: 5)
let c5 = Location(file: .C, rank: 5)
let d5 = Location(file: .D, rank: 5)
let e5 = Location(file: .E, rank: 5)
let f5 = Location(file: .F, rank: 5)
let g5 = Location(file: .G, rank: 5)
let h5 = Location(file: .H, rank: 5)

let a6 = Location(file: .A, rank: 6)
let b6 = Location(file: .B, rank: 6)
let c6 = Location(file: .C, rank: 6)
let d6 = Location(file: .D, rank: 6)
let e6 = Location(file: .E, rank: 6)
let f6 = Location(file: .F, rank: 6)
let g6 = Location(file: .G, rank: 6)
let h6 = Location(file: .H, rank: 6)

let a7 = Location(file: .A, rank: 7)
let b7 = Location(file: .B, rank: 7)
let c7 = Location(file: .C, rank: 7)
let d7 = Location(file: .D, rank: 7)
let e7 = Location(file: .E, rank: 7)
let f7 = Location(file: .F, rank: 7)
let g7 = Location(file: .G, rank: 7)
let h7 = Location(file: .H, rank: 7)

let a8 = Location(file: .A, rank: 8)
let b8 = Location(file: .B, rank: 8)
let c8 = Location(file: .C, rank: 8)
let d8 = Location(file: .D, rank: 8)
let e8 = Location(file: .E, rank: 8)
let f8 = Location(file: .F, rank: 8)
let g8 = Location(file: .G, rank: 8)
let h8 = Location(file: .H, rank: 8)


public struct Location: Equatable {
    let file: File
    let rank: Rank
}

// MARK: Location - Hashable

extension Location: Hashable {
    public var hashValue: Int {
        return rank.hashValue ^ file.hashValue
    }
}

// MARK: Location - Equatable

public func == (left:Location, right:Location) -> Bool {
    return (left.rank == right.rank)  && (left.file == right.file)
}

// MARK: Location - CustomStringConvertible

extension Location: CustomStringConvertible {
    public var description: String {
        get { return "\(file)\(rank)" }
    }
}

//Failable string initializer
extension Location {
    init?(_ value: String) {
        if value.characters.count != 2 { return nil }
        let file = value[value.startIndex].fenFileValue
        if file == nil { return nil }
        let rank = value[value.startIndex.successor()].fenRankValue
        if rank == nil { return nil }
        self.rank = rank!
        self.file = file!
    }
}

//MARK: Extensions

extension Character {
    public var fenFileValue: File? {
        switch self {
        case "a", "A": return .A
        case "b", "B": return .B
        case "c", "C": return .C
        case "d", "D": return .D
        case "e", "E": return .E
        case "f", "F": return .F
        case "g", "G": return .G
        case "h", "H": return .H
        default:
            print("FEN File '\(self)' is not in range 'a'..'h'")
            return nil
        }
    }
}

extension Character {
    public var fenRankValue: Rank? {
        switch self {
        case "1": return 1
        case "2": return 2
        case "3": return 3
        case "4": return 4
        case "5": return 5
        case "6": return 6
        case "7": return 7
        case "8": return 8
        default:
            print("FEN Rank '\(self)' is not in range 1..8")
            return nil
        }
    }
}

extension String {
    public var fenLocation: Location? {
        if self.characters.count == 2 {
            if let file = self[self.startIndex].fenFileValue {
                if let rank = self[self.startIndex.successor()].fenRankValue {
                    return Location(file: file, rank: rank)
                }
            }
        } else {
            print("FEN Location '\(self)' is not two characters.")
        }
        return nil
    }
}
