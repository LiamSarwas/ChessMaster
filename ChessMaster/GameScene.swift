//
//  GameScene.swift
//  ChessBoard
//
//  Created by Liam Sarwas on 11/1/15.
//  Copyright (c) 2015 Liam Sarwas. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.grayColor()
        
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
        
        //set up white pawn row
        for i in 0...7
        {
            let sprite = SKSpriteNode(imageNamed:"White_Pawn")
            let x = CGFloat(40 + 80*i)
            let y = CGFloat(120)
            sprite.position = CGPointMake(x, y)
            sprite.setScale(0.4)
            self.addChild(sprite)
        }
        
        //set up black pawn row
        for i in 0...7
        {
            let sprite = SKSpriteNode(imageNamed:"Black_Pawn")
            let x = CGFloat(40 + 80*i)
            let y = CGFloat(520)
            sprite.position = CGPointMake(x, y)
            sprite.setScale(0.4)
            self.addChild(sprite)
        }
        
        //set up black back row
        var y = CGFloat(600)
        
        let spriteRookLeftBlack = SKSpriteNode(imageNamed:"Black_Rook")
        var x = CGFloat(40)
        spriteRookLeftBlack.position = CGPointMake(x, y)
        spriteRookLeftBlack.setScale(0.4)
        self.addChild(spriteRookLeftBlack)
        
        let spriteRookRightBlack = SKSpriteNode(imageNamed:"Black_Rook")
        x = CGFloat(600)
        spriteRookRightBlack.position = CGPointMake(x, y)
        spriteRookRightBlack.setScale(0.4)
        self.addChild(spriteRookRightBlack)
        
        
        let spriteKnightLeftBlack = SKSpriteNode(imageNamed:"Black_Knight")
        x = CGFloat(120)
        spriteKnightLeftBlack.position = CGPointMake(x, y)
        spriteKnightLeftBlack.setScale(0.4)
        self.addChild(spriteKnightLeftBlack)
        
        let spriteKnightRightBlack = SKSpriteNode(imageNamed:"Black_Knight")
        x = CGFloat(520)
        spriteKnightRightBlack.position = CGPointMake(x, y)
        spriteKnightRightBlack.setScale(0.4)
        self.addChild(spriteKnightRightBlack)
        
        
        let spriteBishopLeftBlack = SKSpriteNode(imageNamed:"Black_Bishop")
        x = CGFloat(200)
        spriteBishopLeftBlack.position = CGPointMake(x, y)
        spriteBishopLeftBlack.setScale(0.4)
        self.addChild(spriteBishopLeftBlack)
        
        let spriteBishopRightBlack = SKSpriteNode(imageNamed:"Black_Bishop")
        x = CGFloat(440)
        spriteBishopRightBlack.position = CGPointMake(x, y)
        spriteBishopRightBlack.setScale(0.4)
        self.addChild(spriteBishopRightBlack)
        
        
        let spriteQueenBlack = SKSpriteNode(imageNamed:"Black_Queen")
        x = CGFloat(280)
        spriteQueenBlack.position = CGPointMake(x, y)
        spriteQueenBlack.setScale(0.4)
        self.addChild(spriteQueenBlack)
        
        let spriteKingBlack = SKSpriteNode(imageNamed:"Black_King")
        x = CGFloat(360)
        spriteKingBlack.position = CGPointMake(x, y)
        spriteKingBlack.setScale(0.4)
        self.addChild(spriteKingBlack)
        
        
        //set up whites back row
        y = CGFloat(40)
        
        let spriteRookLeftWhite = SKSpriteNode(imageNamed:"White_Rook")
        x = CGFloat(40)
        spriteRookLeftWhite.position = CGPointMake(x, y)
        spriteRookLeftWhite.setScale(0.4)
        self.addChild(spriteRookLeftWhite)
        
        let spriteRookRightWhite = SKSpriteNode(imageNamed:"White_Rook")
        x = CGFloat(600)
        spriteRookRightWhite.position = CGPointMake(x, y)
        spriteRookRightWhite.setScale(0.4)
        self.addChild(spriteRookRightWhite)
        
        
        let spriteKnighRightWhite = SKSpriteNode(imageNamed:"White_Knight")
        x = CGFloat(120)
        spriteKnighRightWhite.position = CGPointMake(x, y)
        spriteKnighRightWhite.setScale(0.4)
        self.addChild(spriteKnighRightWhite)
        
        let spriteKnightRightWhite = SKSpriteNode(imageNamed:"White_Knight")
        x = CGFloat(520)
        spriteKnightRightWhite.position = CGPointMake(x, y)
        spriteKnightRightWhite.setScale(0.4)
        self.addChild(spriteKnightRightWhite)
        
        
        let spriteBishopLeftWhite = SKSpriteNode(imageNamed:"White_Bishop")
        x = CGFloat(200)
        spriteBishopLeftWhite.position = CGPointMake(x, y)
        spriteBishopLeftWhite.setScale(0.4)
        self.addChild(spriteBishopLeftWhite)
        
        let spriteBishopRightWhite = SKSpriteNode(imageNamed:"White_Bishop")
        x = CGFloat(440)
        spriteBishopRightWhite.position = CGPointMake(x, y)
        spriteBishopRightWhite.setScale(0.4)
        self.addChild(spriteBishopRightWhite)
        
        
        let spriteQueenWhite = SKSpriteNode(imageNamed:"White_Queen")
        x = CGFloat(280)
        spriteQueenWhite.position = CGPointMake(x, y)
        spriteQueenWhite.setScale(0.4)
        self.addChild(spriteQueenWhite)
        
        let spriteKingWhite = SKSpriteNode(imageNamed:"White_King")
        x = CGFloat(360)
        spriteKingWhite.position = CGPointMake(x, y)
        spriteKingWhite.setScale(0.4)
        self.addChild(spriteKingWhite)
        
    }
    
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
        let location = theEvent.locationInNode(self)
        
        let sprite = SKSpriteNode(imageNamed:"White_Pawn")
        sprite.position = location;
        print(location)
        sprite.setScale(0.4)
        
        /* let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        sprite.runAction(SKAction.repeatActionForever(action))
        */
        self.addChild(sprite)
    }
    
    func convertToLocation(point: CGPoint) -> Location
    {
        var loc = String(Int (point.y/80) + 1)
        let val = Int (point.x/80)
        
        if (val >= 0) && (val < 80)
        {
            loc += "a"
        }
        if (val >= 80) && (val < 160)
        {
            loc += "b"
        }
        if (val >= 160) && (val < 240)
        {
            loc += "c"
        }
        if (val >= 240) && (val < 320)
        {
            loc += "d"
        }
        if (val >= 320) && (val < 400)
        {
            loc += "e"
        }
        if (val >= 400) && (val < 480)
        {
            loc += "f"
        }
        if (val >= 480) && (val < 560)
        {
            loc += "g"
        }
        if (val >= 560) && (val < 640)
        {
            loc += "h"
        }
        
        let location = loc.fenLocation
        return location!
        
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}