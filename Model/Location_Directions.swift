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
        return rank.toNorth().map { Location(file: file, rank: $0) }
    }
    
    var toSouth: [Location]
    {
        return rank.toSouth().map { Location(file: file, rank: $0) }
    }
    
    var toEast: [Location]
    {
        return file.toEast().map { Location(file: $0, rank: rank) }
    }
    
    var toWest: [Location]
    {
        return file.toWest().map { Location(file: $0, rank: rank) }
    }
    
    var toNortheast: [Location]
    {
        return zip(file.toEast(), rank.toNorth()).map { Location(file: $0, rank: $1) }
    }
    
    var toNorthwest: [Location]
    {
        return zip(file.toWest(), rank.toNorth()).map { Location(file: $0, rank: $1) }
    }
    
    var toSoutheast: [Location]
    {
        return zip(file.toEast(), rank.toSouth()).map { Location(file: $0, rank: $1) }
    }
    
    var toSouthwest: [Location]
    {
        return zip(file.toWest(), rank.toSouth()).map { Location(file: $0, rank: $1) }
    }
}
