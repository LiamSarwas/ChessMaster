//
//  GameScene.swift
//  ChessBoard
//
//  Created by Liam Sarwas on 11/1/15.
//  Copyright (c) 2015 Liam Sarwas. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var game:Game! = nil
    var appDelegate: ChessSceneDelegate! = nil
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
    
    override func didMove(to view: SKView)
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
                    sprites[i].append(SKSpriteNode(color: SKColor.white, size:CGSize(width: 70, height: 70)))
                }
                else
                {
                    sprites[i].append(SKSpriteNode(color: SKColor.brown, size:CGSize(width: 70, height: 70)))
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
                sprites[i][j].position = CGPoint(x: x, y: y)
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

    
    override func mouseDown(with theEvent: NSEvent)
    {
        /* Called when a mouse click occurs */
        let location = theEvent.location(in: self)
        let node = atPoint(location)
        
       // print("Node at \(location) is \(node)")
        if let spriteNode = node as? SKSpriteNode
        {
            if spriteNode.texture != nil
            {
                movingSprite = spriteNode
                let node = SKSpriteNode(color: SKColor.yellow, size:CGSize(width: 70, height: 70))
                node.position = spriteNode.position
                movedSprite = node
            }
        }
      
        if let validLocation = convertToLocation(location)
        {
            validLocations = Rules.validMoves(game.board, start: validLocation)
        }
        else
        {
            validLocations = []
        }
        for loc in validLocations
        {
            yellowSquares.append(SKSpriteNode(color: SKColor.yellow, size:CGSize(width: 70, height: 70)))
            yellowSquares.last!.position = convertToPoint(loc)
            self.addChild(yellowSquares.last!)
        }
        
    }
    
    override func mouseDragged(with theEvent: NSEvent)
    {
        let location = theEvent.location(in: self)
        if(movingSprite != nil)
        {
            movingSprite!.position = location
           // self.addChild(movingSprite!)
        }
    }
    
    override func mouseUp(with theEvent: NSEvent)
    {
        let location = theEvent.location(in: self)
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
                    movingSprite!.position = CGPoint(x: CGFloat(spriteX), y: CGFloat(spriteY))
                    
                    if let start = convertToLocation(movedSprite!.position)
                    {
                        let move = (start: start, end: end)
                        
                        game.makeMove(move)
                        if let capturedPiece = game.lastCapturedPiece
                        {
                            if capturedPiece.color == .white
                            {
                                capturedWhitePieces.append(capturedPiece)
                            }
                            if capturedPiece.color == .black
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
            
            self.removeChildren(in: yellowSquares)

            yellowSquares.removeAll()

            setUpBoard()
        }
    }
    
    func convertToLocation(_ point: CGPoint) -> Location?
    {
        let rankIndex = 1 + Int(point.y/80)
        let fileIndex = 1 + Int(point.x/80)
        if let rank = Rank(rankIndex) {
            if let file = File(fileIndex) {
                return Location(file: file, rank: rank)
            }
        }
        return nil
    }
    
    func convertToPoint(_ location: Location) -> CGPoint
    {
        let y = CGFloat(Int(location.rank) * 80 - 40)
        let x = CGFloat(Int(location.file) * 80 - 40)
        return CGPoint(x: x, y: y)
    }
    
    func setUpBoard()
    {
        self.removeChildren(in: sprites)
        sprites.removeAll()

        //set up board from the FEN
        for (location,piece) in game.board
        {
            if piece.color == .white
            {
                if piece.kind == .king
                {
                    let spriteKingWhite = SKSpriteNode(imageNamed:"White_King")
                    spriteKingWhite.position = convertToPoint(location)
                    spriteKingWhite.setScale(0.4)
                    sprites.append(spriteKingWhite)
                    self.addChild(spriteKingWhite)
                }
                if piece.kind == .queen
                {
                    let spriteQueenWhite = SKSpriteNode(imageNamed:"White_Queen")
                    spriteQueenWhite.position = convertToPoint(location)
                    spriteQueenWhite.setScale(0.4)
                    sprites.append(spriteQueenWhite)
                    self.addChild(spriteQueenWhite)
                }
                if piece.kind == .bishop
                {
                    let spriteBishopWhite = SKSpriteNode(imageNamed:"White_Bishop")
                    spriteBishopWhite.position = convertToPoint(location)
                    spriteBishopWhite.setScale(0.4)
                    sprites.append(spriteBishopWhite)
                    self.addChild(spriteBishopWhite)
                }
                if piece.kind == .knight
                {
                    let spriteKnightWhite = SKSpriteNode(imageNamed:"White_Knight")
                    spriteKnightWhite.position = convertToPoint(location)
                    spriteKnightWhite.setScale(0.4)
                    sprites.append(spriteKnightWhite)
                    self.addChild(spriteKnightWhite)
                }
                if piece.kind == .rook
                {
                    let spriteRookWhite = SKSpriteNode(imageNamed:"White_Rook")
                    spriteRookWhite.position = convertToPoint(location)
                    spriteRookWhite.setScale(0.4)
                    sprites.append(spriteRookWhite)
                    self.addChild(spriteRookWhite)
                }
                if piece.kind == .pawn
                {
                    let spritePawnWhite = SKSpriteNode(imageNamed:"White_Pawn")
                    spritePawnWhite.position = convertToPoint(location)
                    spritePawnWhite.setScale(0.4)
                    sprites.append(spritePawnWhite)
                    self.addChild(spritePawnWhite)
                }
            }
            
            if piece.color == .black
            {
                if piece.kind == .king
                {
                    let spriteKingBlack = SKSpriteNode(imageNamed:"Black_King")
                    spriteKingBlack.position = convertToPoint(location)
                    spriteKingBlack.setScale(0.4)
                    sprites.append(spriteKingBlack)
                    self.addChild(spriteKingBlack)
                }
                if piece.kind == .queen
                {
                    let spriteQueenBlack = SKSpriteNode(imageNamed:"Black_Queen")
                    spriteQueenBlack.position = convertToPoint(location)
                    spriteQueenBlack.setScale(0.4)
                    sprites.append(spriteQueenBlack)
                    self.addChild(spriteQueenBlack)
                }
                if piece.kind == .bishop
                {
                    let spriteBishopBlack = SKSpriteNode(imageNamed:"Black_Bishop")
                    spriteBishopBlack.position = convertToPoint(location)
                    spriteBishopBlack.setScale(0.4)
                    sprites.append(spriteBishopBlack)
                    self.addChild(spriteBishopBlack)
                }
                if piece.kind == .knight
                {
                    let spriteKnightBlack = SKSpriteNode(imageNamed:"Black_Knight")
                    spriteKnightBlack.position = convertToPoint(location)
                    spriteKnightBlack.setScale(0.4)
                    sprites.append(spriteKnightBlack)
                    self.addChild(spriteKnightBlack)
                }
                if piece.kind == .rook
                {
                    let spriteRookBlack = SKSpriteNode(imageNamed:"Black_Rook")
                    spriteRookBlack.position = convertToPoint(location)
                    spriteRookBlack.setScale(0.4)
                    sprites.append(spriteRookBlack)
                    self.addChild(spriteRookBlack)
                }
                if piece.kind == .pawn
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
            let point = CGPoint(x: x, y: y)
            i += 1
            
            if piece.kind == .king
            {
                let spriteKingWhite = SKSpriteNode(imageNamed:"White_King")
                spriteKingWhite.position = point
                spriteKingWhite.setScale(0.2)
                sprites.append(spriteKingWhite)
                self.addChild(spriteKingWhite)
            }
            if piece.kind == .queen
            {
                let spriteQueenWhite = SKSpriteNode(imageNamed:"White_Queen")
                spriteQueenWhite.position = point
                spriteQueenWhite.setScale(0.2)
                sprites.append(spriteQueenWhite)
                self.addChild(spriteQueenWhite)
            }
            if piece.kind == .bishop
            {
                let spriteBishopWhite = SKSpriteNode(imageNamed:"White_Bishop")
                spriteBishopWhite.position = point
                spriteBishopWhite.setScale(0.2)
                sprites.append(spriteBishopWhite)
                self.addChild(spriteBishopWhite)
            }
            if piece.kind == .knight
            {
                let spriteKnightWhite = SKSpriteNode(imageNamed:"White_Knight")
                spriteKnightWhite.position = point
                spriteKnightWhite.setScale(0.2)
                sprites.append(spriteKnightWhite)
                self.addChild(spriteKnightWhite)
            }
            if piece.kind == .rook
            {
                let spriteRookWhite = SKSpriteNode(imageNamed:"White_Rook")
                spriteRookWhite.position = point
                spriteRookWhite.setScale(0.2)
                sprites.append(spriteRookWhite)
                self.addChild(spriteRookWhite)
            }
            if piece.kind == .pawn
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
            let point = CGPoint(x: x, y: y)
            i += 1
            
            if piece.kind == .king
            {
                let spriteKingBlack = SKSpriteNode(imageNamed:"Black_King")
                spriteKingBlack.position = point
                spriteKingBlack.setScale(0.2)
                sprites.append(spriteKingBlack)
                self.addChild(spriteKingBlack)
            }
            if piece.kind == .queen
            {
                let spriteQueenBlack = SKSpriteNode(imageNamed:"Black_Queen")
                spriteQueenBlack.position = point
                spriteQueenBlack.setScale(0.2)
                sprites.append(spriteQueenBlack)
                self.addChild(spriteQueenBlack)
            }
            if piece.kind == .bishop
            {
                let spriteBishopBlack = SKSpriteNode(imageNamed:"Black_Bishop")
                spriteBishopBlack.position = point
                spriteBishopBlack.setScale(0.2)
                sprites.append(spriteBishopBlack)
                self.addChild(spriteBishopBlack)
            }
            if piece.kind == .knight
            {
                let spriteKnightBlack = SKSpriteNode(imageNamed:"Black_Knight")
                spriteKnightBlack.position = point
                spriteKnightBlack.setScale(0.2)
                sprites.append(spriteKnightBlack)
                self.addChild(spriteKnightBlack)
            }
            if piece.kind == .rook
            {
                let spriteRookBlack = SKSpriteNode(imageNamed:"Black_Rook")
                spriteRookBlack.position = point
                spriteRookBlack.setScale(0.2)
                sprites.append(spriteRookBlack)
                self.addChild(spriteRookBlack)
            }
            if piece.kind == .pawn
            {
                let spritePawnBlack = SKSpriteNode(imageNamed:"Black_Pawn")
                spritePawnBlack.position = point
                spritePawnBlack.setScale(0.2)
                sprites.append(spritePawnBlack)
                self.addChild(spritePawnBlack)
            }

        }
        
        //Add a turn display
        if game.board.activeColor == .white
        {
            let spriteW = SKSpriteNode(imageNamed: "W")
            spriteW.position = CGPoint(x: CGFloat(740), y: CGFloat(100))
            spriteW.setScale(0.4)
            sprites.append(spriteW)
            self.addChild(spriteW)
        }
        else
        {
            let spriteB = SKSpriteNode(imageNamed: "B")
            spriteB.position = CGPoint(x: CGFloat(740), y: CGFloat(100))
            spriteB.setScale(0.4)
            sprites.append(spriteB)
            self.addChild(spriteB)
        }

        //Update the UI via the delegate
        setMessage()

        let boardValue = Engine.evaluateBoard(game.board)
        let bestMove = Engine.getMove(game.board)
        
        print("The net board value is: \(boardValue)")
        print("The best move is: \(bestMove)")
    }

    func setMessage() {
        var msg = "\(game.board.activeColor)'s move."
        if game.board.isActiveColorInCheck && !game.isCheckMate {
            msg += " You are in Check."
        }
        if game.isOfferOfDrawAvailable {
            msg += " \(game.board.activeColor) has offered a draw."
        }
        if game.isGameOver {
            if let winner = game.winningColor {
                if game.isCheckMate {
                    msg = "Game Over - \(winner) wins by checkmate!"
                } else {
                    msg = "Game Over - \(winner) wins by resignation."
                }
            } else {
                if game.isStaleMate {
                    msg = "Game Over - Draw by stalemate"
                } else {
                    msg = "Game Over - Draw"
                }
            }
        }
        appDelegate.updateMessage(msg)
    }
    override func update(_ currentTime: TimeInterval)
    {
        /* Called before each frame is rendered */
    }
}
