//
//  PGNDeserializer.swift
//  ChessMaster
//
//  Created by Regan Sarwas on 12/20/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

//enum JSONValue {
//    case
//    Null,
//    True,
//    False,
//    Number(Double),
//    Text(String),
//    List([JSONValue]),
//    Object([String:JSONValue])
//}

struct ParseError: ErrorType {}

enum Token {
    case
//    MoveNumber(Int),
//    MoveString(String),
//    EndDraw,
//    EndBlackWin,
//    EndWhiteWin,
//    EndPause,
    KingSideCastle,
    QueenSideCastle
}

func HistoryWithMoveText(string: String) -> History? {
    return try! PGNDeserializer.parseMoveText(string)
}

struct PGNDeserializer {

    struct UnicodeParser {
        let view: String.UnicodeScalarView
        let index: String.UnicodeScalarIndex

        init(view: String.UnicodeScalarView, index: String.UnicodeScalarIndex) {
            self.view = view
            self.index = index
        }

        init(viewSkippingBOM view: String.UnicodeScalarView) {
            if view.startIndex < view.endIndex && view[view.startIndex] == UnicodeScalar(0xFEFF) {
                self.init(view: view, index: view.startIndex.successor())
                return
            }
            self.init(view: view, index: view.startIndex)
        }

        func successor() -> UnicodeParser {
            return UnicodeParser(view: view, index: index.successor())
        }
    }

    static let whitespaceScalars = "\u{20}\u{09}\u{0A}\u{0D}".unicodeScalars
    static func consumeWhitespace(parser: UnicodeParser) -> UnicodeParser {
        var index = parser.index
        let view = parser.view
        let endIndex = view.endIndex
        while index < endIndex && whitespaceScalars.contains(view[index]) {
            index = index.successor()
        }
        return UnicodeParser(view: view, index: index)
    }

    static let moveScalars = "KQRBNPabcdefgh12345678x=+#".unicodeScalars
//    static let endScalars = "012/-*".unicodeScalars
//    static let castleScalars = "O-".unicodeScalars
//    static let annotationScalars = "!?".unicodeScalars

    struct StructureScalar {
        static let DollarSign     = UnicodeScalar("$")
//        static let BeginArray     = UnicodeScalar(0x5B) // [ left square bracket
//        static let EndArray       = UnicodeScalar(0x5D) // ] right square bracket
//        static let BeginObject    = UnicodeScalar(0x7B) // { left curly bracket
//        static let EndObject      = UnicodeScalar(0x7D) // } right curly bracket
//        static let NameSeparator  = UnicodeScalar(0x3A) // : colon
//        static let ValueSeparator = UnicodeScalar(0x2C) // , comma
    }

    static func consumeStructure(scalar: UnicodeScalar, input: UnicodeParser) throws -> UnicodeParser? {
        if let parser = try consumeScalar(scalar, input: consumeWhitespace(input)) {
            return consumeWhitespace(parser)
        }
        return nil
    }

    static func takeScalar(input: UnicodeParser) -> (UnicodeScalar, UnicodeParser)? {
        guard input.index < input.view.endIndex else {
            return nil
        }
        return (input.view[input.index], input.successor())
    }

    static func consumeScalar(scalar: UnicodeScalar, input: UnicodeParser) throws -> UnicodeParser? {
        switch takeScalar(input) {
        case nil:
            throw ParseError()
        case let (taken, parser)? where taken == scalar:
            return parser
        default:
            return nil
        }
    }

    static func consumeSequence(sequence: String, input: UnicodeParser) throws -> UnicodeParser? {
        var parser = input
        for scalar in sequence.unicodeScalars {
            guard let newParser = try consumeScalar(scalar, input: parser) else {
                return nil
            }
            parser = newParser
        }
        return parser
    }

//    static func takeInClass(matchClass: String.UnicodeScalarView, count: UInt = UInt.max, input: UnicodeParser) -> (String.UnicodeScalarView, UnicodeParser)? {
//        var output = String.UnicodeScalarView()
//        var remaining = count
//        var parser = input
//        while remaining > 0, let (taken, newParser) = takeScalar(parser) where matchClass.contains(taken) {
//            output.append(taken)
//            parser = newParser
//            remaining -= 1
//        }
//        guard output.count > 0 && (count != UInt.max || remaining == 0) else {
//            return nil
//        }
//        return (output, parser)
//    }

    //MARK: - Integer parsing
    static func parseDots(input: UnicodeParser) throws -> (Int, UnicodeParser) {
        let view = input.view
        var index = input.index
        var count = 0
        while index < view.endIndex && "." == view[index] {
            index = index.successor()
            count += 1
        }
        return (count, UnicodeParser(view: view, index: index))
    }

    static let numberScalars = "0123456789".unicodeScalars
    static func parseNumber(input: UnicodeParser) throws -> (Int, UnicodeParser)? {
        let view = input.view
        let endIndex = view.endIndex
        var index = input.index
        var value = String.UnicodeScalarView()
        while index < endIndex && numberScalars.contains(view[index]) {
            value.append(view[index])
            index = index.successor()
        }
        guard value.count > 0, let result = Int(String(value)) else {
            return nil
        }
        return (result, UnicodeParser(view: view, index: index))
    }

    static func parseNAG(input: UnicodeParser) throws -> (Int, UnicodeParser)? {
        guard let beginParser = try consumeStructure(StructureScalar.DollarSign, input: input) else {
            return nil
        }
        return try parseNumber(beginParser)
    }

    static func parseMoveNumber(input: UnicodeParser) throws -> UnicodeParser {
        let beginParser = consumeWhitespace(input)
        guard let (move, newParser) = try parseNumber(consumeWhitespace(beginParser)) else {
            //print("No integer at move number location")
            return beginParser
        }
        print("move # \(move)")
        let (count, newParser2) = try parseDots(newParser)
        print("dot count # \(count)")
        return consumeWhitespace(newParser2)
    }

    static func parseEnd(input: UnicodeParser) throws -> (Bool, UnicodeParser) {
        let beginParser = consumeWhitespace(input)
        if let parser = try consumeSequence("1-0", input: beginParser) {
            return (true, parser)
        }
        else if let parser = try consumeSequence("0-1", input: beginParser) {
            return (true, parser)
        }
        else if let parser = try consumeSequence("1/2-1/2", input: beginParser) {
            return (true, parser)
        }
        else if let parser = try consumeSequence("*", input: beginParser) {
            return (true, parser)
        }
        return (false, beginParser)
    }

    static func parseMove(input: UnicodeParser, board: Board) throws -> (Move, UnicodeParser)? {
        if let parser = try consumeSequence("O-O", input: input) {
            return (castleOn(.KingSideCastle, with: board), parser)
        }
        else if let parser = try consumeSequence("O-O-O", input: input) {
            return (castleOn(.QueenSideCastle, with: board), parser)
        }

        let view = input.view
        let endIndex = view.endIndex
        var index = input.index
        var value = String.UnicodeScalarView()
        while index < endIndex && moveScalars.contains(view[index]) {
            value.append(view[index])
            index = index.successor()
        }
        print("move string:\(value):")
        guard value.count > 0, let move = makeMove(String(value), board:board) else {
            return nil
        }
        return (move, UnicodeParser(view: view, index: index))
    }

    static func parseAnnotation(input: UnicodeParser) throws -> UnicodeParser {
        if let (_,parser) = try parseNAG(input) {
            return parser
        }
        return input
    }

    static func parseMoveText(input: String) throws -> History? {
        let history = History()
        var board = Board()
        var parser = PGNDeserializer.UnicodeParser(viewSkippingBOM: input.unicodeScalars)
        while true {
            let (end, newParser) = try parseEnd(parser)
            if end {
                //print("Game Over!")
                return history
            }
            let newParser2 = try parseMoveNumber(newParser)
            // TODO: validate move number, and color of the move (number of dots)
            guard let (move, newParser3) = try parseMove(newParser2, board: board) else {
                return nil
            }
            history.appendMove(move, board: board)
//            guard let (newBoard, _) = board.makeMove(move) else {
//                return nil
//            }
//            board = newBoard
            parser = try parseAnnotation(newParser3)
            //TODO: Add annotation to the move
        }
    }

    static func makeMove(input: String, board: Board) -> Move? {
        return (e2,e4)
    }
    
    static func castleOn(side: Token, with board: Board) -> Move {
        switch board.activeColor {
        case .Black:
            switch side {
            case .KingSideCastle:
                return (e8, g8)
            case .QueenSideCastle:
                return (e8, b8)
            }
        case .White:
            switch side {
            case .KingSideCastle:
                return (e1, g1)
            case .QueenSideCastle:
                return (e1, b1)
            }
        }
    }
}