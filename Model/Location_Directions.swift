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
        return self.rank.toNorth().map { Location(file: self.file, rank: $0) }
    }
    
    var toSouth: [Location]
    {
        return self.rank.toSouth().map { Location(file: self.file, rank: $0) }
    }
    
    var toEast: [Location]
    {
        return self.file.toEast().map { Location(file: $0, rank: self.rank) }
    }
    
    var toWest: [Location]
    {
        return self.file.toWest().map { Location(file: $0, rank: self.rank) }
    }
    
    var toNortheast: [Location]
    {
        return zip(self.file.toEast(), self.rank.toNorth()).map { Location(file: $0, rank: $1) }
    }
    
    var toNorthwest: [Location]
    {
        return zip(self.file.toWest(), self.rank.toNorth()).map { Location(file: $0, rank: $1) }
    }
    
    var toSoutheast: [Location]
    {
        return zip(self.file.toEast(), self.rank.toSouth()).map { Location(file: $0, rank: $1) }
    }
    
    var toSouthwest: [Location]
    {
        return zip(self.file.toWest(), self.rank.toSouth()).map { Location(file: $0, rank: $1) }
    }
}