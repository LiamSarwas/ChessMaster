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
