//
//  AppDelegate.swift
//  ChessBoard
//
//  Created by Liam Sarwas on 11/1/15.
//  Copyright (c) 2015 Liam Sarwas. All rights reserved.
//


import Cocoa
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, ChessSceneDelegate {
    
    var game = Game()
    var scene: GameScene! = nil

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var messageTextField: NSTextField!

    @IBAction func reset(_ sender: NSButton) {
        //TODO only show when game is over
        print("reset")
        game = Game()
        scene.game = game
        scene.setUpBoard()
    }
    @IBAction func resign(_ sender: NSButton) {
        print("resign")
        game.resign()
        scene.setUpBoard()
    }
    @IBAction func offerDraw(_ sender: NSButton) {
        print("offer draw")
        game.offerDraw()
        scene.setUpBoard()
    }
    @IBAction func acceptDraw(_ sender: NSButton) {
        //TODO: Hide button when no draw offered"
        print("accept draw")
        game.acceptDraw()
        scene.setUpBoard()
    }
    @IBAction func claimDraw(_ sender: NSButton) {
        print("request draw")
        game.claimDraw()
        scene.setUpBoard()
    }
    @IBAction func undo(_ sender: NSButton) {
        print("undo")
        game.undoMove()
        scene.setUpBoard()
    }
    @IBAction func redo(_ sender: NSButton) {
        //TODO: only show when appropriate
        print("redo")
        game.redoMove()
        scene.setUpBoard()
    }

    func updateMessage(_ text:String) {
        messageTextField.cell!.title = text
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        if let tryScene = GameScene(fileNamed:"GameScene") {
            scene = tryScene

            /* Set the scale mode to scale to fit the window */
            let dim = CGSize(width: 840, height: 640)
            window.contentMinSize = dim
            window.contentMaxSize = dim
            window.setContentSize(dim)
            scene.scaleMode = .aspectFit
            
            scene.game = game
            updateMessage("The Game is on! - \(game.board.activeColor)'s move.")
            scene.appDelegate = self
            self.skView!.presentScene(scene)

            /* Sprite Kit applies additional optimizations to improve rendering performance */
            self.skView!.ignoresSiblingOrder = true
            
            //self.skView!.showsFPS = true
            //self.skView!.showsNodeCount = true
        } else {
            updateMessage("Fatal Error.  Failed to load scene.  Throw error and quit")
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

protocol ChessSceneDelegate {
    func updateMessage(_ text:String)
    //func showAcceptDraw()
    //func gameOver()
    //func showRedo()
}
