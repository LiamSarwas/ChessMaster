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
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        /* Pick a size for the scene */
        if let scene = GameScene(fileNamed:"GameScene") {
            /* Set the scale mode to scale to fit the window */
            
            let dim = CGSize(width: 640, height: 640)
            window.contentMinSize = dim
            window.contentMaxSize = dim
            window.setContentSize(dim)
            
            scene.scaleMode = .ResizeFill
            
            self.skView!.presentScene(scene)
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            self.skView!.ignoresSiblingOrder = true
            
            //self.skView!.showsFPS = true
            //self.skView!.showsNodeCount = true
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}
