//
//  Location_Directions.swift
//  ChessMaster
//
//  Created by Regan Sarwas on 11/15/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//


extension Location {
    var toNorth: [Location]
    {
        if self.rank == Rank.maxValue {
            return []
        }
        return ((self.rank + 1)...Rank.maxValue).map { Location(rank:$0, file: self.file) }
    }
    
    var toSouth: [Location]
    {
        if self.rank == Rank.minValue {
            return []
        }
        return (Rank.minValue...(self.rank - 1)).reverse().map { Location(rank:$0, file: self.file) }
    }
    
    var toEast: [Location]
    {
        return self.file.toEast().map { Location(rank:self.rank, file: $0) }
    }
    
    var toWest: [Location]
    {
        return self.file.toWest().map { Location(rank:self.rank, file: $0) }
    }
    
    var toNortheast: [Location]
    {
        return [self]
    }
    
    var toNorthwest: [Location]
    {
        return [self]
    }
    
    var toSoutheast: [Location]
    {
        return [self]
    }
    
    var toSouthwest: [Location]
    {
        return [self]
    }
}