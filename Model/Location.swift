//
//  Location.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

import Foundation


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

public struct Rank {
    static let minValue = 1
    static let maxValue = 8
    static let allValues = minValue...maxValue
}

public struct Location: Equatable {
    let rank: Int
    let file: File
}

// MARK: Hashable

extension Location: Hashable {
    public var hashValue: Int {
        return rank.hashValue ^ file.hashValue
    }
}

// MARK: Equatable

public func == (left:Location, right:Location) -> Bool {
    return (left.rank == right.rank)  && (left.file == right.file)
}

// MARK: CustomStringConvertible

extension Location: CustomStringConvertible {
    public var description: String {
        get {
            switch file {
            case .A: return "a\(rank)"
            case .B: return "b\(rank)"
            case .C: return "c\(rank)"
            case .D: return "d\(rank)"
            case .E: return "e\(rank)"
            case .F: return "f\(rank)"
            case .G: return "g\(rank)"
            case .H: return "h\(rank)"
            }
        }
    }
}

extension Character {
    public var fenFileValue: File? {
        switch self {
        case "a": return .A
        case "b": return .B
        case "c": return .C
        case "d": return .D
        case "e": return .E
        case "f": return .F
        case "g": return .G
        case "h": return .H
        default:
            print("FEN File '\(self)' is not in range 'a'..'h'")
            return nil
        }
    }
}

extension Character {
    public var fenRankValue: Int? {
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
                    return Location(rank: rank, file: file)
                }
            }
        } else {
            print("FEN Location '\(self)' is not two characters.")
        }
        return nil
    }
}
