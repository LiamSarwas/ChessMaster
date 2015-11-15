//
//  Utilities.swift
//  Chess_cmd
//
//  Created by Regan Sarwas on 11/4/15.
//  Copyright © 2015 Regan Sarwas. All rights reserved.
//

extension String {
    func split(separator:Character = " ") -> [String] {
        return self.characters.split{$0 == separator}.map(String.init)
    }
}
