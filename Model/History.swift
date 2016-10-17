//
//  History.swift
//  Chess
//
//  Created by Regan Sarwas on 11/1/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

// History is a collection of moves
// The board state before the move is also recorded,
// because it is impossible to reason about a move without
// knowing the state of the board at the time of the move.

final class History {
    fileprivate var _history: [(move: Move, board: Board)] = []
    fileprivate var _historyIndex: Int?
    // If the history index is non-nil, then the _history index must be a
    // valid index into the _histroy collection, and current board is the
    // board at that location in the history collection.


    var board: Board? {
        if let index = _historyIndex {
            return _history[index].board
        }
        return nil
    }

    func occurrencesOfBoard(_ board: Board) -> Int {
        return _history.filter({$0.board == board}).count
    }

    func backup() {
        if _historyIndex == nil {
            _historyIndex = _history.count - 1
        } else {
            _historyIndex = max(0, _historyIndex! - 1)
        }
    }

    func forward() {
        if _historyIndex != nil {
            _historyIndex! += 1
            if _historyIndex == _history.count {
                _historyIndex = nil
            }
        }
    }

    func appendMove(_ move: Move, board: Board) {
        // If we append a move after backing up, then move and board are already on the history
        // at _historyIndex, so we delete everything after that, so that move and board are the last items
        // and clear the _historyIndex
        if let index = _historyIndex {
            assert(board == _history[index].board && move == _history[index].move)
            while index < _history.count {
                _history.removeLast()
            }
            _historyIndex = nil
        } else {
            _history.append((move: move, board: board))
        }
    }
}

extension History: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        return PGNstring
    }
    var debugDescription: String {
        return PGNstring
    }

    var PGNstring: String
    {
        var response: String = ""
        for index in 0..<_history.count {
            // TODO: Implement the PGN Protocol
            if (index % 2 == 0) {
                response += "\(1 + index / 2). \(_history[index].move.start)\(_history[index].move.end) "
            } else {
                response += "\(_history[index].move.start)\(_history[index].move.end) "
            }
        }
        return response
    }
}


