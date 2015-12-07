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
            game.makeMove((Location("e2")!, Location("e4")!))
            XCTAssertTrue("\(game)" == "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1")
            game.makeMove((Location("b8")!, Location("c6")!))
            XCTAssertTrue("\(game)" == "r1bqkbnr/pppppppp/2n5/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 1 2")
        } else {
            XCTFail()
        }
    }

    func testCheck() {
        if let game = "7k/8/8/8/8/8/8/7R b - - 0 1".fenGame {
            XCTAssertTrue(game.board.isActiveColorInCheck)
            XCTAssertTrue(game.board.activeColor == .Black)
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

    func testCastleBlackKingSide() {
        if let game = "r3k2r/8/8/8/8/8/8/R3K2R b KQk - 0 1".fenGame {
            let move = (start:Location("e8")!, end:Location("g8")!)
            game.makeMove(move)
            XCTAssertTrue("\(game)" == "r4rk1/8/8/8/8/8/8/R3K2R w KQ - 1 2")
        } else {
            XCTFail()
        }
    }

    func testCastleBlackQueenSide() {
        if let game = "r3k2r/8/8/8/8/8/8/R3K2R b KQkq - 0 1".fenGame {
            let move = (start:Location("e8")!, end:Location("c8")!)
            game.makeMove(move)
            XCTAssertTrue("\(game)" == "2kr3r/8/8/8/8/8/8/R3K2R w KQ - 1 2")
        } else {
            XCTFail()
        }
    }
    
    func testCastleWhiteKingSide() {
        if let game = "r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1".fenGame {
            let move = (start:Location("e1")!, end:Location("g1")!)
            game.makeMove(move)
            XCTAssertTrue("\(game)" == "r3k2r/8/8/8/8/8/8/R4RK1 b kq - 1 1")
        } else {
            XCTFail()
        }
    }

    func testCastleWhiteQueenSide() {
        if let game = "r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1".fenGame {
            let move = (start:Location("e1")!, end:Location("c1")!)
            game.makeMove(move)
            XCTAssertTrue("\(game)" == "r3k2r/8/8/8/8/8/8/2KR3R b kq - 1 1")
        } else {
            XCTFail()
        }
    }
    
    func testCastleOK() {
        if let game = "4k2r/R7/8/8/8/8/8/3R4 b k - 0 1".fenGame {
            let start = Location("e8")!
            let end = Location("g8")!
            XCTAssertTrue(Rules.validMoves(game.board, start: start).contains(end))
        } else {
            XCTFail()
        }
    }
    func testCastleFailNotOption() {
        if let game = "4k2r/R7/8/8/8/8/8/3R4 b q - 0 1".fenGame {
            let start = Location("e8")!
            let end = Location("g8")!
            XCTAssertFalse(Rules.validMoves(game.board, start: start).contains(end))
        } else {
            XCTFail()
        }
    }
    func testCastleFailPieceInWay() {
        if let game = "4k1br/R7/8/8/8/8/8/3R4 b k - 0 1".fenGame {
            let start = Location("e8")!
            let end = Location("g8")!
            XCTAssertFalse(Rules.validMoves(game.board, start: start).contains(end))
        } else {
            XCTFail()
        }
    }
    func testCastleFailKingCheck() {
        if let game = "4k2r/R7/8/8/8/8/8/4R3 b k - 0 1".fenGame {
            let start = Location("e8")!
            let end = Location("g8")!
            XCTAssertFalse(Rules.validMoves(game.board, start: start).contains(end))
        } else {
            XCTFail()
        }
    }
    func testCastleFailPassingCheck() {
        if let game = "4k2r/R7/8/8/8/8/8/5R2 b k - 0 1".fenGame {
            let start = Location("e8")!
            let end = Location("g8")!
            XCTAssertFalse(Rules.validMoves(game.board, start: start).contains(end))
        } else {
            XCTFail()
        }
    }
    func testCastleFailDestibationCheck() {
        if let game = "4k2r/R7/8/8/8/8/8/6R1 b k - 0 1".fenGame {
            let start = Location("e8")!
            let end = Location("g8")!
            XCTAssertFalse(Rules.validMoves(game.board, start: start).contains(end))
        } else {
            XCTFail()
        }
    }
    //This check is to ensure the an invalid move does not crash
    func testMakeInvalidMoveWithoutValidation() {
        let game = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".fenGame!
        let board = game.board
        let start = Location("e7")!
        let end = Location("f1")!
        let move = (start: start, end: end)
        if let (newboard,_) = game.board.makeMoveWithoutValidation(move) {
            XCTAssertTrue(newboard != game.board)
            XCTAssertTrue(board == game.board)
        }
    }

    // average: 0.0000005, relative standard deviation: 212.378%
    func testPerformanceActiveColorPropertyAccess() {
        let game = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".fenGame!
        self.measureBlock {
            game.board.inActiveColor
        }
    }
    // average: 0.0001, relative standard deviation: 16.009%
    func testPerformanceActiveColorInCheckCheck() {
        let game = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".fenGame!
        self.measureBlock {
            game.board.isActiveColorInCheck
        }
    }
    // average: 0.001, relative standard deviation: 56.229%
    func testPerformanceActiveColorHasMovesCheck() {
        let game = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".fenGame!
        self.measureBlock {
            game.board.activeColorHasMoves
        }
    }
    // average: 0.001, relative standard deviation: 19.922%
    func testPerformanceGameOverCheck() {
        let game = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".fenGame!
        self.measureBlock {
            game.isGameOver
        }
    }
    // average: 0.001, relative standard deviation: 24.707%
    func testPerformanceStaleMateCheck() {
        let game = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".fenGame!
        self.measureBlock {
            game.isStaleMate
        }
    }
    // average: 0.0001, relative standard deviation: 86.550%
    func testPerformanceCheckMateCheck() {
        let game = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".fenGame!
        self.measureBlock {
            game.isCheckMate
        }
    }
    // average: 0.000038, relative standard deviation: 47.129%
    func testPerformanceMakeMoveWithoutValidation() {
        let game = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".fenGame!
        let start = Location("e2")!
        let end = Location("e4")!
        let move = (start: start, end: end)
        self.measureBlock {
            game.board.makeMoveWithoutValidation(move)
        }
    }

}
