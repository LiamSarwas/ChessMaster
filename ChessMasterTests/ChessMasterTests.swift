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
            let move = (start:Location(rank: 8, file: .E), end:Location(rank: 8, file: .G))
            game.makeMove(move)
            XCTAssertTrue("\(game)" == "r4rk1/8/8/8/8/8/8/R3K2R w KQ - 1 2")
        } else {
            XCTFail()
        }
    }

    func testCastleBlackQueenSide() {
        if let game = "r3k2r/8/8/8/8/8/8/R3K2R b KQkq - 0 1".fenGame {
            let move = (start:Location(rank: 8, file: .E), end:Location(rank: 8, file: .C))
            game.makeMove(move)
            XCTAssertTrue("\(game)" == "2kr3r/8/8/8/8/8/8/R3K2R w KQ - 1 2")
        } else {
            XCTFail()
        }
    }
    
    func testCastleWhiteKingSide() {
        if let game = "r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1".fenGame {
            let move = (start:Location(rank: 1, file: .E), end:Location(rank: 1, file: .G))
            game.makeMove(move)
            XCTAssertTrue("\(game)" == "r3k2r/8/8/8/8/8/8/R4RK1 b kq - 1 1")
        } else {
            XCTFail()
        }
    }

    func testCastleWhiteQueenSide() {
        if let game = "r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1".fenGame {
            let move = (start:Location(rank: 1, file: .E), end:Location(rank: 1, file: .C))
            game.makeMove(move)
            XCTAssertTrue("\(game)" == "r3k2r/8/8/8/8/8/8/2KR3R b kq - 1 1")
        } else {
            XCTFail()
        }
    }
    
    func testCastleOK() {
        if let game = "4k2r/R7/8/8/8/8/8/3R4 b k - 0 1".fenGame {
            let start = Location(rank: 8, file: .E)
            let end = Location(rank: 8, file: .G)
            XCTAssertTrue(Rules.validMoves(game.board, start: start).contains(end))
        } else {
            XCTFail()
        }
    }
    func testCastleFailNotOption() {
        if let game = "4k2r/R7/8/8/8/8/8/3R4 b q - 0 1".fenGame {
            let start = Location(rank: 8, file: .E)
            let end = Location(rank: 8, file: .G)
            XCTAssertFalse(Rules.validMoves(game.board, start: start).contains(end))
        } else {
            XCTFail()
        }
    }
    func testCastleFailPieceInWay() {
        if let game = "4k1br/R7/8/8/8/8/8/3R4 b k - 0 1".fenGame {
            let start = Location(rank: 8, file: .E)
            let end = Location(rank: 8, file: .G)
            XCTAssertFalse(Rules.validMoves(game.board, start: start).contains(end))
        } else {
            XCTFail()
        }
    }
    func testCastleFailKingCheck() {
        if let game = "4k2r/R7/8/8/8/8/8/4R3 b k - 0 1".fenGame {
            let start = Location(rank: 8, file: .E)
            let end = Location(rank: 8, file: .G)
            XCTAssertFalse(Rules.validMoves(game.board, start: start).contains(end))
        } else {
            XCTFail()
        }
    }
    func testCastleFailPassingCheck() {
        if let game = "4k2r/R7/8/8/8/8/8/5R2 b k - 0 1".fenGame {
            let start = Location(rank: 8, file: .E)
            let end = Location(rank: 8, file: .G)
            XCTAssertFalse(Rules.validMoves(game.board, start: start).contains(end))
        } else {
            XCTFail()
        }
    }
    func testCastleFailDestibationCheck() {
        if let game = "4k2r/R7/8/8/8/8/8/6R1 b k - 0 1".fenGame {
            let start = Location(rank: 8, file: .E)
            let end = Location(rank: 8, file: .G)
            XCTAssertFalse(Rules.validMoves(game.board, start: start).contains(end))
        } else {
            XCTFail()
        }
    }

    func testPerformanceExample1() {
        let game = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".fenGame!
        self.measureBlock {
            game.board.inActiveColor
        }
    }
    func testPerformanceExample2() {
        let game = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".fenGame!
        self.measureBlock {
            game.board.isActiveColorInCheck
        }
    }
    func testPerformanceExample3() {
        let game = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".fenGame!
        self.measureBlock {
            game.board.activeColorHasMoves
        }
    }
    func testPerformanceExample4() {
        let game = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".fenGame!
        self.measureBlock {
            game.CheckForGameOver()
        }
    }

}
