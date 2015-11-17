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
        return self.rank.toNorth().map { Location(rank:$0, file: self.file) }
    }
    
    var toSouth: [Location]
    {
        return self.rank.toSouth().map { Location(rank:$0, file: self.file) }
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
        return zip(self.rank.toNorth(),self.file.toEast()).map { Location(rank:$0, file:$1) }
    }
    
    var toNorthwest: [Location]
    {
        return zip(self.rank.toNorth(),self.file.toWest()).map { Location(rank:$0, file:$1) }
    }
    
    var toSoutheast: [Location]
    {
        return zip(self.rank.toSouth(),self.file.toEast()).map { Location(rank:$0, file:$1) }
    }
    
    var toSouthwest: [Location]
    {
        return zip(self.rank.toSouth(),self.file.toWest()).map { Location(rank:$0, file:$1) }
    }
}