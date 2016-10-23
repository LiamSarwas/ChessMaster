//
//  Rank.swift
//  ChessMaster
//
//  Created by Regan Sarwas on 12/12/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

public enum Rank: Int {
    case r1 = 1, r2, r3, r4, r5, r6, r7, r8
    static let allForwardValues = [Rank.r1, r2, r3, r4, r5, r6, r7, r8]
    static let allReverseValues = [Rank.r8, r7, r6, r5, r4, r3, r2, r1]
    static let min = Rank.r1
    static let max = Rank.r8

    func toNorth() -> ArraySlice<Rank> {
        if self == Rank.max {
            return []
        }
        return Rank.allForwardValues[self.rawValue...7]
    }

    func toSouth() -> ArraySlice<Rank> {
        if self == Rank.min {
            return []
        }
        return Rank.allReverseValues[(9 - self.rawValue)...7]
    }
}

func + (rank: Rank, n: Int) -> Rank? {
    return Rank(Int(rank) + n)
}

func - (rank: Rank, n: Int) -> Rank? {
    return Rank(Int(rank) - n)
}

// Note: Equatable and Hashable come for free with rawValue Enums

// MARK: - Comparable

public func < (lhs: Rank, rhs: Rank) -> Bool {
    return (lhs.rawValue < rhs.rawValue)
}

// MARK: - CustomStringConvertible

extension Rank: CustomStringConvertible {
    public var description: String {
        return "\(rawValue)"
    }
}

// MARK: - Failable initializer from Character

extension Rank {
    init?(_ value: Character) {
        switch value {
        case "1":
            self.init(rawValue: 1)
        case "2":
            self.init(rawValue: 2)
        case "3":
            self.init(rawValue: 3)
        case "4":
            self.init(rawValue: 4)
        case "5":
            self.init(rawValue: 5)
        case "6":
            self.init(rawValue: 6)
        case "7":
            self.init(rawValue: 7)
        case "8":
            self.init(rawValue: 8)
        default:
            return nil
        }
    }
}

// MARK: - Failable initializer from Int

extension Rank {
    init?(_ value: Int) {
        if value < 1 || 8 < value {
            return nil
        }
        self.init(rawValue: value)
    }
}


// MARK: - Opaque conversion to Int

extension Int {
    init(_ value: Rank) {
        self.init(value.rawValue)
    }
}
