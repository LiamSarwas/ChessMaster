//
//  GameScene.swift
//  ChessBoard
//
//  Created by Liam Sarwas on 11/1/15.
//  Copyright (c) 2015 Liam Sarwas. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var game = Game(boardState: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".fenGame!)
    //var game = "r1bqkb1r/8/8/8/8/8/8/R1BQKB1R b Q - 71 36".fenGame!
    var movingSprite : SKSpriteNode?
    var movedSprite : SKSpriteNode?
    var validLocations : [Location] = []
    var yellowSquares : [SKSpriteNode] = []
    var sprites : [SKSpriteNode] = []
    var capturedWhitePieces : [Piece] = []
    var capturedBlackPieces : [Piece] = []
    var capturedWhitePieceTextures : [SKSpriteNode] = []
    var capturedBlackPieceTextures : [SKSpriteNode] = []
    
    override func didMoveToView(view: SKView)
    {
        
        var sprites : [[SKSpriteNode]] = []
        
        for i in 0...7
        {
            sprites.append([])
            for j in 0...7
            {
                //Below is a logical equivalent to the XOR function, used to alternate the black and white squares on the board
                if(((j%2 == 0) && (i%2 == 1)) || ((j%2 == 1) && (i%2 == 0)))
                {
                    sprites[i].append(SKSpriteNode(color: SKColor.whiteColor(), size:CGSizeMake(70, 70)))
                }
                else
                {
                    sprites[i].append(SKSpriteNode(color: SKColor.brownColor(), size:CGSizeMake(70, 70)))
                }
            }
        }
        
        for i in 0...7
        {
            for j in 0...7
            {
                let x = CGFloat(40 + 80*i)
                let y = CGFloat(40 + 80*j)
                sprites[i][j].zPosition = -100
                sprites[i][j].position = CGPointMake(x, y)
            }
        }
        
        for i in 0...7
        {
            for j in 0...7
            {
                self.addChild(sprites[i][j])
            }
        }
        
        setUpBoard()
        
    }
    
    override func mouseDown(theEvent: NSEvent)
    {
        /* Called when a mouse click occurs */
        let location = theEvent.locationInNode(self)
        let node = nodeAtPoint(location)
        
       // print("Node at \(location) is \(node)")
        if let spriteNode = node as? SKSpriteNode
        {
            if spriteNode.texture != nil
            {
                movingSprite = spriteNode
                let node = SKSpriteNode(color: SKColor.yellowColor(), size:CGSizeMake(70, 70))
                node.position = spriteNode.position
                movedSprite = node
            }
        }
      
        if let validLocation = convertToLocation(location)
        {
            validLocations = game.validMoves(validLocation)
        }
        else
        {
            validLocations = []
        }
        for loc in validLocations
        {
            yellowSquares.append(SKSpriteNode(color: SKColor.yellowColor(), size:CGSizeMake(70, 70)))
            yellowSquares.last!.position = convertToPoint(loc)
            self.addChild(yellowSquares.last!)
        }
        
    }
    
    override func mouseDragged(theEvent: NSEvent)
    {
        let location = theEvent.locationInNode(self)
        if(movingSprite != nil)
        {
            movingSprite!.position = location
           // self.addChild(movingSprite!)
        }
    }
    
    override func mouseUp(theEvent: NSEvent)
    {
        let location = theEvent.locationInNode(self)
        let x = Int(location.x)
        let y = Int(location.y)
        var spriteX = 0
        var spriteY = 0
        
        if(movingSprite != nil)
        {
            if (x >= 0 && x < 80)
            {
                spriteX = 40
            }
            if (x >= 80 && x < 160)
            {
                spriteX = 120
            }
            if (x >= 160 && x < 240)
            {
                spriteX = 200
            }
            if (x >= 240 && x < 320)
            {
                spriteX = 280
            }
            if (x >= 320 && x < 400)
            {
                spriteX = 360
            }
            if (x >= 400 && x < 480)
            {
                spriteX = 440
            }
            if (x >= 480 && x < 560)
            {
                spriteX = 520
            }
            if (x >= 560 && x < 640)
            {
                spriteX = 600
            }
            
            if (y >= 0 && y < 80)
            {
                spriteY = 40
            }
            if (y >= 80 && y < 160)
            {
                spriteY = 120
            }
            if (y >= 160 && y < 240)
            {
                spriteY = 200
            }
            if (y >= 240 && y < 320)
            {
                spriteY = 280
            }
            if (y >= 320 && y < 400)
            {
                spriteY = 360
            }
            if (y >= 400 && y < 480)
            {
                spriteY = 440
            }
            if (y >= 480 && y < 560)
            {
                spriteY = 520
            }
            if (y >= 560 && y < 640)
            {
                spriteY = 600
            }
            var resetSprite = true
            if let end = convertToLocation(movingSprite!.position)
            {
                if validLocations.contains(end)
                {
                    movingSprite!.position = CGPointMake(CGFloat(spriteX), CGFloat(spriteY))
                    
                    if let start = convertToLocation(movedSprite!.position)
                    {
                        let move = (start: start, end: end)
                        
                        game.makeMove(move)
                        if let capturedPiece = game.lastCapturedPiece
                        {
                            if capturedPiece.color == .White
                            {
                                capturedWhitePieces.append(capturedPiece)
                            }
                            if capturedPiece.color == .Black
                            {
                                capturedBlackPieces.append(capturedPiece)
                            }
                        }
                        movingSprite = nil
                        resetSprite = false
                    }
                }
            }
            if resetSprite
            {
                movingSprite!.position = movedSprite!.position
                movingSprite = nil
            }
            
            self.removeChildrenInArray(yellowSquares)
            self.removeChildrenInArray(sprites)
            
            yellowSquares.removeAll()
            sprites.removeAll()
            
            setUpBoard()
        }
    }
    
    func convertToLocation(point: CGPoint) -> Location?
    {
        var loc = ""
        let valX = Int (point.x)
        let valY = Int (point.y)
        if (valY >= 0 && valY < 640) && (valX >= 0 && valX < 640)
        {
            if (valX >= 0) && (valX < 80)
            {
                loc += "a"
            }
            if (valX >= 80) && (valX < 160)
            {
                loc += "b"
            }
            if (valX >= 160) && (valX < 240)
            {
                loc += "c"
            }
            if (valX >= 240) && (valX < 320)
            {
                loc += "d"
            }
            if (valX >= 320) && (valX < 400)
            {
                loc += "e"
            }
            if (valX >= 400) && (valX < 480)
            {
                loc += "f"
            }
            if (valX >= 480) && (valX < 560)
            {
                loc += "g"
            }
            if (valX >= 560) && (valX < 640)
            {
                loc += "h"
            }
            
            let rank = Int (valY/80) + 1
            loc += String(rank)
        }
        else
        {
            loc = ""
        }
        
        
        let location = loc.fenLocation
        return location
    }
    
    func convertToPoint(loc: Location) -> CGPoint
    {
        let y = CGFloat (loc.rank.value*80 - 40)
        var x = CGFloat(0)
        
        if loc.file == .A
        {
            x = CGFloat(40)
        }
        if loc.file == .B
        {
            x = CGFloat(120)
        }
        if loc.file == .C
        {
            x = CGFloat(200)
        }
        if loc.file == .D
        {
            x = CGFloat(280)
        }
        if loc.file == .E
        {
            x = CGFloat(360)
        }
        if loc.file == .F
        {
            x = CGFloat(440)
        }
        if loc.file == .G
        {
            x = CGFloat(520)
        }
        if loc.file == .H
        {
            x = CGFloat(600)
        }
        
        let point = CGPointMake(x, y)
        return point
    }
    
    func setUpBoard()
    {
        //set up board from the FEN
        for (location,piece) in game.board
        {
            if piece.color == .White
            {
                if piece.kind == .King
                {
                    let spriteKingWhite = SKSpriteNode(imageNamed:"White_King")
                    spriteKingWhite.position = convertToPoint(location)
                    spriteKingWhite.setScale(0.4)
                    sprites.append(spriteKingWhite)
                    self.addChild(spriteKingWhite)
                }
                if piece.kind == .Queen
                {
                    let spriteQueenWhite = SKSpriteNode(imageNamed:"White_Queen")
                    spriteQueenWhite.position = convertToPoint(location)
                    spriteQueenWhite.setScale(0.4)
                    sprites.append(spriteQueenWhite)
                    self.addChild(spriteQueenWhite)
                }
                if piece.kind == .Bishop
                {
                    let spriteBishopWhite = SKSpriteNode(imageNamed:"White_Bishop")
                    spriteBishopWhite.position = convertToPoint(location)
                    spriteBishopWhite.setScale(0.4)
                    sprites.append(spriteBishopWhite)
                    self.addChild(spriteBishopWhite)
                }
                if piece.kind == .Knight
                {
                    let spriteKnightWhite = SKSpriteNode(imageNamed:"White_Knight")
                    spriteKnightWhite.position = convertToPoint(location)
                    spriteKnightWhite.setScale(0.4)
                    sprites.append(spriteKnightWhite)
                    self.addChild(spriteKnightWhite)
                }
                if piece.kind == .Rook
                {
                    let spriteRookWhite = SKSpriteNode(imageNamed:"White_Rook")
                    spriteRookWhite.position = convertToPoint(location)
                    spriteRookWhite.setScale(0.4)
                    sprites.append(spriteRookWhite)
                    self.addChild(spriteRookWhite)
                }
                if piece.kind == .Pawn
                {
                    let spritePawnWhite = SKSpriteNode(imageNamed:"White_Pawn")
                    spritePawnWhite.position = convertToPoint(location)
                    spritePawnWhite.setScale(0.4)
                    sprites.append(spritePawnWhite)
                    self.addChild(spritePawnWhite)
                }
            }
            
            if piece.color == .Black
            {
                if piece.kind == .King
                {
                    let spriteKingBlack = SKSpriteNode(imageNamed:"Black_King")
                    spriteKingBlack.position = convertToPoint(location)
                    spriteKingBlack.setScale(0.4)
                    sprites.append(spriteKingBlack)
                    self.addChild(spriteKingBlack)
                }
                if piece.kind == .Queen
                {
                    let spriteQueenBlack = SKSpriteNode(imageNamed:"Black_Queen")
                    spriteQueenBlack.position = convertToPoint(location)
                    spriteQueenBlack.setScale(0.4)
                    sprites.append(spriteQueenBlack)
                    self.addChild(spriteQueenBlack)
                }
                if piece.kind == .Bishop
                {
                    let spriteBishopBlack = SKSpriteNode(imageNamed:"Black_Bishop")
                    spriteBishopBlack.position = convertToPoint(location)
                    spriteBishopBlack.setScale(0.4)
                    sprites.append(spriteBishopBlack)
                    self.addChild(spriteBishopBlack)
                }
                if piece.kind == .Knight
                {
                    let spriteKnightBlack = SKSpriteNode(imageNamed:"Black_Knight")
                    spriteKnightBlack.position = convertToPoint(location)
                    spriteKnightBlack.setScale(0.4)
                    sprites.append(spriteKnightBlack)
                    self.addChild(spriteKnightBlack)
                }
                if piece.kind == .Rook
                {
                    let spriteRookBlack = SKSpriteNode(imageNamed:"Black_Rook")
                    spriteRookBlack.position = convertToPoint(location)
                    spriteRookBlack.setScale(0.4)
                    sprites.append(spriteRookBlack)
                    self.addChild(spriteRookBlack)
                }
                if piece.kind == .Pawn
                {
                    let spritePawnBlack = SKSpriteNode(imageNamed:"Black_Pawn")
                    spritePawnBlack.position = convertToPoint(location)
                    spritePawnBlack.setScale(0.4)
                    sprites.append(spritePawnBlack)
                    self.addChild(spritePawnBlack)
                }
            }
        }
        
        var i = 0
        for piece in capturedWhitePieces
        {
            let x = CGFloat(690)
            let y = CGFloat(620 - 40*i)
            let point = CGPointMake(x, y)
            i++
            
            if piece.kind == .King
            {
                let spriteKingWhite = SKSpriteNode(imageNamed:"White_King")
                spriteKingWhite.position = point
                spriteKingWhite.setScale(0.2)
                sprites.append(spriteKingWhite)
                self.addChild(spriteKingWhite)
            }
            if piece.kind == .Queen
            {
                let spriteQueenWhite = SKSpriteNode(imageNamed:"White_Queen")
                spriteQueenWhite.position = point
                spriteQueenWhite.setScale(0.2)
                sprites.append(spriteQueenWhite)
                self.addChild(spriteQueenWhite)
            }
            if piece.kind == .Bishop
            {
                let spriteBishopWhite = SKSpriteNode(imageNamed:"White_Bishop")
                spriteBishopWhite.position = point
                spriteBishopWhite.setScale(0.2)
                sprites.append(spriteBishopWhite)
                self.addChild(spriteBishopWhite)
            }
            if piece.kind == .Knight
            {
                let spriteKnightWhite = SKSpriteNode(imageNamed:"White_Knight")
                spriteKnightWhite.position = point
                spriteKnightWhite.setScale(0.2)
                sprites.append(spriteKnightWhite)
                self.addChild(spriteKnightWhite)
            }
            if piece.kind == .Rook
            {
                let spriteRookWhite = SKSpriteNode(imageNamed:"White_Rook")
                spriteRookWhite.position = point
                spriteRookWhite.setScale(0.2)
                sprites.append(spriteRookWhite)
                self.addChild(spriteRookWhite)
            }
            if piece.kind == .Pawn
            {
                let spritePawnWhite = SKSpriteNode(imageNamed:"White_Pawn")
                spritePawnWhite.position = point
                spritePawnWhite.setScale(0.2)
                sprites.append(spritePawnWhite)
                self.addChild(spritePawnWhite)
            }
        }
        
        i = 0
        for piece in capturedBlackPieces
        {
            let x = CGFloat(790)
            let y = CGFloat(620 - 40*i)
            let point = CGPointMake(x, y)
            i++
            
            if piece.kind == .King
            {
                let spriteKingBlack = SKSpriteNode(imageNamed:"Black_King")
                spriteKingBlack.position = point
                spriteKingBlack.setScale(0.2)
                sprites.append(spriteKingBlack)
                self.addChild(spriteKingBlack)
            }
            if piece.kind == .Queen
            {
                let spriteQueenBlack = SKSpriteNode(imageNamed:"Black_Queen")
                spriteQueenBlack.position = point
                spriteQueenBlack.setScale(0.2)
                sprites.append(spriteQueenBlack)
                self.addChild(spriteQueenBlack)
            }
            if piece.kind == .Bishop
            {
                let spriteBishopBlack = SKSpriteNode(imageNamed:"Black_Bishop")
                spriteBishopBlack.position = point
                spriteBishopBlack.setScale(0.2)
                sprites.append(spriteBishopBlack)
                self.addChild(spriteBishopBlack)
            }
            if piece.kind == .Knight
            {
                let spriteKnightBlack = SKSpriteNode(imageNamed:"Black_Knight")
                spriteKnightBlack.position = point
                spriteKnightBlack.setScale(0.2)
                sprites.append(spriteKnightBlack)
                self.addChild(spriteKnightBlack)
            }
            if piece.kind == .Rook
            {
                let spriteRookBlack = SKSpriteNode(imageNamed:"Black_Rook")
                spriteRookBlack.position = point
                spriteRookBlack.setScale(0.2)
                sprites.append(spriteRookBlack)
                self.addChild(spriteRookBlack)
            }
            if piece.kind == .Pawn
            {
                let spritePawnBlack = SKSpriteNode(imageNamed:"Black_Pawn")
                spritePawnBlack.position = point
                spritePawnBlack.setScale(0.2)
                sprites.append(spritePawnBlack)
                self.addChild(spritePawnBlack)
            }

        }
        
        //Add a turn display
        if game.activeColor == .White
        {
            let spriteW = SKSpriteNode(imageNamed: "W")
            spriteW.position = CGPointMake(CGFloat(740), CGFloat(100))
            spriteW.setScale(0.4)
            sprites.append(spriteW)
            self.addChild(spriteW)
        }
        else
        {
            let spriteB = SKSpriteNode(imageNamed: "B")
            spriteB.position = CGPointMake(CGFloat(740), CGFloat(100))
            spriteB.setScale(0.4)
            sprites.append(spriteB)
            self.addChild(spriteB)
        }
        
        let boardValue = Engine.evaluateBoard(game)
      //  let bestMove = Engine.getMove(game)
        
        print("The net board value is: \(boardValue)")
     //   print("The best move is: \(bestMove)")
    }

    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
    }
}