//
//  ChessMasterTests.swift
//  ChessMasterTests
//
//  Created by Regan Sarwas on 11/15/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

import XCTest
@testable import ChessMaster

class ChessMasterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGameMove() {
        if let game = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".fenGame {
            game.makeMove((Location(rank: 2, file: .E), Location(rank: 4, file: .E)))
            XCTAssertTrue("\(game)" == "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1")
            game.makeMove((Location(rank: 8, file: .B), Location(rank: 6, file: .C)))
            XCTAssertTrue("\(game)" == "r1bqkbnr/pppppppp/2n5/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 1 2")
        } else {
            XCTFail()
        }
    }

    func testCheck() {
        if let game = "7k/8/8/8/8/8/8/7R b - - 0 1".fenGame {
            XCTAssertTrue(game.isActiveColorInCheck)
            XCTAssertTrue(game.activeColor == .Black)
        } else {
            XCTFail()
        }
    }

    func testCheckMate() {
        if let game = "7k/8/8/8/8/8/8/6RR b - - 0 1".fenGame {
            XCTAssertTrue(game.isGameOver)
            XCTAssertTrue(game.isCheckMate)
            XCTAssertTrue(game.winningColor! == .White)
        } else {
            XCTFail()
        }
    }

    func testStaleMate() {
        if let game = "7k/R7/8/8/8/8/8/6R1 b - - 0 1".fenGame {
            XCTAssertTrue(game.isGameOver)
            XCTAssertTrue(game.isStaleMate)
            XCTAssertTrue(game.winningColor == nil)
        } else {
            XCTFail()
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
