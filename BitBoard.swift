//
//  BitBoard.swift
//  ChessMaster
//
//  Created by Liam Sarwas on 12/9/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

import Foundation

struct BitBoard
{
    //bitboard representation
    //LSB is h1
    //MSB is a8
    var AllPieces: UInt64 = 0
    
    var AllWhite: UInt64 = 0
    var AllBlack: UInt64 = 0
    
    var WhitePawns: UInt64 = 0
    var WhiteKnights: UInt64 = 0
    var WhiteBishops: UInt64 = 0
    var WhiteRooks: UInt64 = 0
    var WhiteQueens: UInt64 = 0
    var WhiteKing: UInt64 = 0
    
    var BlackPawns: UInt64 = 0
    var BlackKnights: UInt64 = 0
    var BlackBishops: UInt64 = 0
    var BlackRooks: UInt64 = 0
    var BlackQueens: UInt64 = 0
    var BlackKing: UInt64 = 0
    
    static let EdgeMask: UInt64 =       0b0000000001111110011111100111111001111110011111100111111000000000
    static let LeftEdgeMask: UInt64 =   0b0111111101111111011111110111111101111111011111110111111101111111
    static let RightEdgeMask: UInt64 =  0b1111111011111110111111101111111011111110111111101111111011111110
    static let TopEdgeMask: UInt64 =    0b0000000011111111111111111111111111111111111111111111111111111111
    static let BottomEdgeMask: UInt64 = 0b1111111111111111111111111111111111111111111111111111111100000000
    
    static var rookMoveMasks: [UInt64] = []
    static var bishopMoveMasks: [UInt64] = []
    
    static var allRookOccupancyVariations = [[UInt64]]()
    static var allBishopOccupancyVariations = [[UInt64]]()
    
    static var rookMoveDatabase = [[UInt64]]()
    
    //inits the board state to a standard board
    init()
    {
        WhitePawns =   0b0000000000000000000000000000000000000000000000001111111100000000
        WhiteKnights = 0b0000000000000000000000000000000000000000000000000000000001000010
        WhiteBishops = 0b0000000000000000000000000000000000000000000000000000000000100100
        WhiteRooks =   0b0000000000000000000000000000000000000000000000000000000010000001
        WhiteQueens =  0b0000000000000000000000000000000000000000000000000000000000010000
        WhiteKing =    0b0000000000000000000000000000000000000000000000000000000000001000
        
        BlackPawns =   0b0000000011111111000000000000000000000000000000000000000000000000
        BlackKnights = 0b0100001000000000000000000000000000000000000000000000000000000000
        BlackBishops = 0b0010010000000000000000000000000000000000000000000000000000000000
        BlackRooks =   0b1000000100000000000000000000000000000000000000000000000000000000
        BlackQueens =  0b0001000000000000000000000000000000000000000000000000000000000000
        BlackKing =    0b0000100000000000000000000000000000000000000000000000000000000000
        
        AllWhite = WhitePawns | WhiteKnights | WhiteBishops | WhiteRooks | WhiteQueens | WhiteKing
        AllBlack = BlackPawns | BlackKnights | BlackBishops | BlackRooks | BlackQueens | BlackKing
        
        AllPieces = AllWhite | AllBlack
    }

    init(input: UInt64)
    {
        AllPieces = input
    }
    
    
    static func rookMoveMaskGenerator(/*loc: Location*/ loc: Int) -> UInt64
    {
        let currentRookLocation: UInt64 = 1 << UInt64(loc)
        var rookMask: UInt64 = 0
        //check if its in the center, if so, we dont care about edges
        if currentRookLocation & EdgeMask != 0
        {
            var oldRookMask: UInt64 = 0
            
            var left: UInt64 = 0
            var right: UInt64 = 0
            var up: UInt64 = 0
            var down: UInt64 = 0
            if (currentRookLocation << 1 & EdgeMask != 0)
            {
                left = currentRookLocation << 1
            }
            if (currentRookLocation >> 1 & EdgeMask != 0)
            {
                right = currentRookLocation >> 1
            }
            if (currentRookLocation << 8 & EdgeMask != 0)
            {
                up = currentRookLocation << 8
            }
            if (currentRookLocation >> 8 & EdgeMask != 0)
            {
                down = currentRookLocation >> 8
            }
            rookMask = left | right | up | down
            
            while oldRookMask & rookMask != rookMask
            {
                oldRookMask = rookMask
                
                rookMask = rookMask & EdgeMask
                if (left << 1 & EdgeMask != 0)
                {
                    left = left << 1
                }
                if (right >> 1 & EdgeMask != 0)
                {
                    right = right >> 1
                }
                if (up << 8 & EdgeMask != 0)
                {
                    up = up << 8
                }
                if (down >> 8 & EdgeMask != 0)
                {
                    down = down >> 8
                }
                
                rookMask = rookMask | left
                rookMask = rookMask | right
                rookMask = rookMask | up
                rookMask = rookMask | down
            }
        }
        //if it isnt, we need to look at edges to make the mask right i think
        else
        {
            if currentRookLocation & LeftEdgeMask == 0
            {
                var oldRookMask: UInt64 = 0
                var right: UInt64 = 0
                var up: UInt64 = 0
                var down: UInt64 = 0

                right = currentRookLocation >> 1
                
                if (currentRookLocation << 8 & TopEdgeMask != 0)
                {
                    up = currentRookLocation << 8
                }
                if (currentRookLocation >> 8 & BottomEdgeMask != 0)
                {
                    down = currentRookLocation >> 8
                }
                
                rookMask = right | up | down
                
                while oldRookMask & rookMask != rookMask
                {
                    oldRookMask = rookMask
                    if (right >> 1 & RightEdgeMask != 0)
                    {
                        right = right >> 1
                    }
                    if (up << 8 & TopEdgeMask != 0)
                    {
                        up = up << 8
                    }
                    if (down >> 8 & BottomEdgeMask != 0)
                    {
                        down = down >> 8
                    }
                    rookMask = rookMask | right
                    rookMask = rookMask | up
                    rookMask = rookMask | down
                }
            }
            if currentRookLocation & RightEdgeMask == 0
            {
                var oldRookMask: UInt64 = 0
                var left: UInt64 = 0
                var up: UInt64 = 0
                var down: UInt64 = 0
                
                left = currentRookLocation << 1
                
                if (currentRookLocation << 8 & TopEdgeMask != 0)
                {
                    up = currentRookLocation << 8
                }
                if (currentRookLocation >> 8 & BottomEdgeMask != 0)
                {
                    down = currentRookLocation >> 8
                }
                
                rookMask = left | up | down
                
                while oldRookMask & rookMask != rookMask
                {
                    oldRookMask = rookMask
                    if (left << 1 & RightEdgeMask != 0)
                    {
                        left = left << 1
                    }
                    if (up << 8 & TopEdgeMask != 0)
                    {
                        up = up << 8
                    }
                    if (down >> 8 & BottomEdgeMask != 0)
                    {
                        down = down >> 8
                    }
                    rookMask = rookMask | left
                    rookMask = rookMask | up
                    rookMask = rookMask | down
                }
            }
            if currentRookLocation & TopEdgeMask == 0
            {
                var oldRookMask: UInt64 = 0
                var right: UInt64 = 0
                var left: UInt64 = 0
                var down: UInt64 = 0
                
                down = currentRookLocation >> 8
                
                if (currentRookLocation << 1 & LeftEdgeMask != 0)
                {
                    left = currentRookLocation << 1
                }
                if ((currentRookLocation >> 1 & RightEdgeMask != 0) && (currentRookLocation & RightEdgeMask != 0))
                {
                    right = currentRookLocation >> 1
                }
                
                rookMask = right | left | down
                
                while oldRookMask & rookMask != rookMask
                {
                    oldRookMask = rookMask
                    if (right >> 1 & RightEdgeMask != 0)
                    {
                        right = right >> 1
                    }
                    if (left << 1 & LeftEdgeMask != 0)
                    {
                        left = left << 1
                    }
                    if (down >> 8 & BottomEdgeMask != 0)
                    {
                        down = down >> 8
                    }
                    rookMask = rookMask | right
                    rookMask = rookMask | left
                    rookMask = rookMask | down
                }
            }
            if currentRookLocation & BottomEdgeMask == 0
            {
                var oldRookMask: UInt64 = 0
                var right: UInt64 = 0
                var left: UInt64 = 0
                var up: UInt64 = 0
                
                up = currentRookLocation << 8
                
                if ((currentRookLocation << 1 & LeftEdgeMask != 0) && (currentRookLocation & LeftEdgeMask != 0))
                {
                    left = currentRookLocation << 1
                }
                if (currentRookLocation >> 1 & RightEdgeMask != 0)
                {
                    right = currentRookLocation >> 1
                }
                
                rookMask = right | left | up
                
                while oldRookMask & rookMask != rookMask
                {
                    oldRookMask = rookMask
                    if (right >> 1 & RightEdgeMask != 0)
                    {
                        right = right >> 1
                    }
                    if (left << 1 & LeftEdgeMask != 0)
                    {
                        left = left << 1
                    }
                    if (up << 8 & TopEdgeMask != 0)
                    {
                        up = up << 8
                    }
                    rookMask = rookMask | right
                    rookMask = rookMask | left
                    rookMask = rookMask | up
                }
            }
        }
        return rookMask
    }
    
    static func makeMasks()
    {
        for i in 0...63
        {
            rookMoveMasks.append(rookMoveMaskGenerator(i))
            //bishopMoveMasks.append(bishopMoveMaskGenerator(i))
        }
    }

    static func generateRookOccupancyPermutations(loc: Int) -> [UInt64]
    {
        var bitPermutations: [UInt64] = []
        if rookMoveMasks == []
        {
            self.makeMasks()
        }
        
        let rookMoveMask: UInt64 = rookMoveMasks[loc]
        var bitIndexes: [Int] = []
        var bitIndexArray: [Int] = []
        let mask: UInt64 = 1
        for i: UInt64 in (0...63).reverse()
        {
            if ((mask << i) & rookMoveMask == (mask << i))
            {
                bitIndexes.append(1)
            }
            else
            {
                bitIndexes.append(0)
            }
        }
        
        for i in 0...63
        {
            if bitIndexes[i] == 1
            {
                
                bitIndexArray += [i]
            }
        }

        var curPermutationArray: [Int] = []
        var result: UInt64 = 0
        for _ in 0...63
        {
            curPermutationArray.append(0)
        }
        
        for i in 1..<Int(pow(Double(2), Double(bitIndexArray.count))) + 1
        {
            for j in 0..<bitIndexArray.count
            {
                if i%(Int(pow(Double(2), Double(j)))) == 0
                {
                    if(curPermutationArray[bitIndexArray[bitIndexArray.count-(j+1)]] == 1)
                    {
                        curPermutationArray[bitIndexArray[bitIndexArray.count-(j+1)]] = 0
                    }
                    else
                    {
                        curPermutationArray[bitIndexArray[bitIndexArray.count-(j+1)]] = 1
                    }
                    
                }
            }
            result = 0
            for k in 0...63
            {
                if curPermutationArray[k] == 1
                {
                    result = (result | UInt64(1 << (63 - k)))
                }
            }
            bitPermutations.append(result)
         }
        return bitPermutations
    }
    
    static func generateRookOccupancyVariations()
    {
        for i in 0...63
        {
            allRookOccupancyVariations.append(generateRookOccupancyPermutations(i))
        }
    }
    
    
    static func generateRookMoves(occupancyBoard: UInt64, loc: Int) -> UInt64
    {
        var moveBoard: UInt64 = 0
        var newMoveBoard: UInt64 = 0
        let newLoc = loc
        
        let location: UInt64 = UInt64(1) << UInt64(newLoc)
        
        var left: UInt64 = 0
        var right: UInt64 = 0
        var up: UInt64 = 0
        var down: UInt64 = 0
        
        if (location & EdgeMask != 0)
        {
            if(occupancyBoard & location == 0)
            {
                left = location << 1
                right = location >> 1
                up = location << 8
                down = location >> 8
            }
            moveBoard = left | up | down | right
            
            while newMoveBoard != moveBoard
            {
                if (left & EdgeMask != 0)
                {
                    if(occupancyBoard & left == 0)
                    {
                        left = left << 1
                    }
                }
                if (right & EdgeMask != 0)
                {
                    if(occupancyBoard & right == 0)
                    {
                        right = right >> 1
                    }
                }
                if (up & EdgeMask != 0)
                {
                    if(occupancyBoard & up == 0)
                    {
                        up = up << 8
                    }
                }
                if (down & EdgeMask != 0)
                {
                    if(occupancyBoard & down == 0)
                    {
                        down = down >> 8
                    }
                }
                newMoveBoard = moveBoard
                moveBoard = moveBoard | left | right | up | down
            }
        }
        
        if(location & RightEdgeMask != 0)
        {
            left = location << 1
            up = location << 8
            down = location >> 8
            
            moveBoard = left | up | down
            
            while moveBoard != newMoveBoard
            {
                if (left & EdgeMask != 0)
                {
                    if(left & occupancyBoard != 0)
                    {
                        left = left << 1
                    }
                }
                if (up & EdgeMask != 0)
                {
                    if(up & occupancyBoard != 0)
                    {
                        up = up << 8
                    }
                }
                if (down & EdgeMask != 0)
                {
                    if(down & occupancyBoard != 0)
                    {
                        down = down >> 8
                    }
                }
                newMoveBoard = moveBoard
                moveBoard = moveBoard | left | up | down
            }
        }
        
        if(location & LeftEdgeMask != 0)
        {
            right = location >> 1
            up = location << 8
            down = location >> 8
            
            moveBoard =  right | up | down
            
            while moveBoard != newMoveBoard
            {
                if (right & EdgeMask != 0)
                {
                    if(right & occupancyBoard != 0)
                    {
                        right = right >> 1
                    }
                }
                if (up & EdgeMask != 0)
                {
                    if(up & occupancyBoard != 0)
                    {
                        up = up << 8
                    }
                }
                if (down & EdgeMask != 0)
                {
                    if(down & occupancyBoard != 0)
                    {
                        down = down >> 8
                    }
                }
                newMoveBoard = moveBoard
                moveBoard = moveBoard | right | up | down
            }
        }
        
        if(location & TopEdgeMask != 0)
        {
            right = location >> 1
            left = location << 1
            down = location >> 8
            
            moveBoard =  right | left | down
            
            while moveBoard != newMoveBoard
            {
                if (right & EdgeMask != 0)
                {
                    if(right & occupancyBoard != 0)
                    {
                        right = right >> 1
                    }
                }
                if (left & EdgeMask != 0)
                {
                    if(left & occupancyBoard != 0)
                    {
                        left = left << 1
                    }
                }
                if (down & EdgeMask != 0)
                {
                    if(down & occupancyBoard != 0)
                    {
                        down = down >> 8
                    }
                }
                newMoveBoard = moveBoard
                moveBoard = moveBoard | right | left | down
            }
        }
        
        if(location & BottomEdgeMask != 0)
        {
            right = location >> 1
            up = location << 8
            left = location << 1
            
            moveBoard =  right | up | left
            
            while moveBoard != newMoveBoard
            {
                if (right & EdgeMask != 0)
                {
                    if(right & occupancyBoard != 0)
                    {
                        right = right >> 1
                    }
                }
                if (up & EdgeMask != 0)
                {
                    if(up & occupancyBoard != 0)
                    {
                        up = up << 8
                    }
                }
                if (left & EdgeMask != 0)
                {
                    if(left & occupancyBoard != 0)
                    {
                        left = left << 1
                    }
                }
                newMoveBoard = moveBoard
                moveBoard = moveBoard | right | up | left
            }
        }
        
        return moveBoard
    }
    
    static func buildRookMoveDatabase()
    {
        makeMasks()
        generateRookOccupancyVariations()
        
        for i in 0...63
        {
            var placesholderArray: [UInt64] = []
            for _ in 0..<Int(pow(Double(2), Double(64-rookBits[i])))
            {
                placesholderArray.append(0)
            }
            rookMoveDatabase.append(placesholderArray)
        }
   
        for k in 0...63
        {
            for j in 0..<Int(pow(Double(2), Double(64-rookBits[k])))
            {
                
                let index = Int((allRookOccupancyVariations[k][j] &* rookMagicNumber[k]) >> rookBits[k])
                rookMoveDatabase[k][index] = generateRookMoves(allRookOccupancyVariations[k][j], loc: k)
            }
        }
    }
    
    static func retrieveRookMove(board: UInt64, loc: Int) -> UInt64
    {
        let index = Int(((rookMoveMasks[loc] & board) &* rookMagicNumber[loc]) >> rookBits[loc])
        return rookMoveDatabase[loc][index]
    }
    
    static func writeRookMoves()
    {
        let flatmapDB = rookMoveDatabase.flatMap {$0}
        let filemgr = NSFileManager.defaultManager()
        let data = NSData(bytes: flatmapDB, length: flatmapDB.count*sizeof(UInt64))
        filemgr.createFileAtPath("/Users/Liam/Desktop/rookmoves", contents: data, attributes: nil)
        
    }
    
    static func readRookMoves() -> [[UInt64]]
    {
        let filemgr = NSFileManager.defaultManager()
        let data = filemgr.contentsAtPath("/Users/Liam/Desktop/rookmoves")
        
        let count = data!.length / sizeof(UInt64)
    
        var array = [UInt64](count: count, repeatedValue: 0)
        data!.getBytes(&array, length: count * sizeof(UInt64))
    
        var database: [[UInt64]] = [[]]
        var counter = 0
        for i in 0...63
        {
            var filler: [UInt64] = []
            for _ in 0..<Int(pow(Double(2), Double(64-rookBits[i])))
            {
                filler.append(array[counter])
                counter++
            }
            database.append(filler)
        }
        return database

    }
    
    
    
    
    //credit for the magic numbers http://www.afewmorelines.com/understanding-magic-bitboards-in-chess-programming/
    
    static let rookMagicNumber: [UInt64] = [0xa180022080400230, 0x40100040022000, 0x80088020001002, 0x80080280841000, 0x4200042010460008, 0x4800a0003040080, 0x400110082041008, 0x8000a041000880, 0x10138001a080c010, 0x804008200480, 0x10011012000c0, 0x22004128102200, 0x200081201200c, 0x202a001048460004, 0x81000100420004, 0x4000800380004500, 0x208002904001, 0x90004040026008, 0x208808010002001, 0x2002020020704940, 0x8048010008110005, 0x6820808004002200, 0xa80040008023011, 0xb1460000811044, 0x4204400080008ea0, 0xb002400180200184, 0x2020200080100380, 0x10080080100080, 0x2204080080800400, 0xa40080360080, 0x2040604002810b1, 0x8c218600004104, 0x8180004000402000, 0x488c402000401001, 0x4018a00080801004, 0x1230002105001008, 0x8904800800800400, 0x42000c42003810, 0x8408110400b012, 0x18086182000401, 0x2240088020c28000, 0x1001201040c004, 0xa02008010420020, 0x10003009010060, 0x4008008008014, 0x80020004008080, 0x282020001008080, 0x50000181204a0004, 0x102042111804200, 0x40002010004001c0, 0x19220045508200, 0x20030010060a900, 0x8018028040080, 0x88240002008080, 0x10301802830400, 0x332a4081140200, 0x8080010a601241, 0x1008010400021, 0x4082001007241, 0x211009001200509, 0x8015001002441801, 0x801000804000603, 0xc0900220024a401, 0x1000200608243]

    static let rookBits: [UInt64] = [52,53,53,53,53,53,53,52,53,54,54,54,54,54,54,53,
        53,54,54,54,54,54,54,53,53,54,54,54,54,54,54,53,
        53,54,54,54,54,54,54,53,53,54,54,54,54,54,54,53,
        53,54,54,54,54,54,54,53,52,53,53,53,53,53,53,52]

}



extension UInt64
{
    var asBoard: String
        {
            var output = ""
            var mask: UInt64 = 1 << 63
            for _ in 0...7
            {
                for _ in 0...7
                {
                    if mask & self == mask
                    {
                        output += "1"
                    }
                    else
                    {
                        output += "0"
                    }
                    
                    mask = mask >> 1
                }
                output += "\n"
            }
            return output
    }
}

extension BitBoard: CustomDebugStringConvertible, CustomStringConvertible
{
    var description: String
        {
            var output = ""
            var mask: UInt64 = 1 << 63
            for _ in 0...7
            {
                for _ in 0...7
                {
                    if mask & AllPieces == mask
                    {
                        output += "1"
                    }
                    else
                    {
                        output += "0"
                    }
                    
                    mask = mask >> 1
                }
                output += "\n"
            }
            return output
    }
    
    var debugDescription: String
    {
            return description
    }
}