//
//  File.swift
//  ChessMaster
//
//  Created by Regan Sarwas on 12/12/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

public enum File: Int {
    case A = 1, B, C, D, E, F, G, H
    static let allForwardValues = [File.A, B, C, D, E, F, G, H]
    static let allReverseValues = [File.H, G, F, E, D, C, B, A]
    static let min = File.A
    static let max = File.H

    func toEast() -> ArraySlice<File> {
        if self == File.max {
            return []
        }
        return File.allForwardValues[self.rawValue...7]
    }

    func toWest() -> ArraySlice<File> {
        if self == File.min {
            return []
        }
        return File.allReverseValues[(9 - self.rawValue)...7]
    }
}

func + (file: File, n: Int) -> File? {
    return File(Int(file) + n)
}

func - (file: File, n: Int) -> File? {
    return File(Int(file) - n)
}

// Note: Equatable and Hashable come for free with rawValue Enums

// MARK: - Comparable

public func < (lhs: File, rhs: File) -> Bool {
    return (lhs.rawValue < rhs.rawValue)
}


// MARK: - CustomStringConvertible

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

// MARK: - Failable initializer from Character

extension File {
    init?(_ value: Character) {
        switch value {
        case "a", "A":
            self.init(rawValue: 1)
        case "b", "B":
            self.init(rawValue: 2)
        case "c", "C":
            self.init(rawValue: 3)
        case "d", "D":
            self.init(rawValue: 4)
        case "e", "E":
            self.init(rawValue: 5)
        case "f", "F":
            self.init(rawValue: 6)
        case "g", "G":
            self.init(rawValue: 7)
        case "h", "H":
            self.init(rawValue: 8)
        default:
            return nil
        }
    }
}

// MARK: - Failable initializer from Int

extension File {
    init?(_ value: Int) {
        if value < 1 || 8 < value {
            return nil
        }
        self.init(rawValue: value)
    }
}

// MARK: - Opaque conversion to Int

extension Int {
    init(_ value: File) {
        self.init(value.rawValue)
    }
}
