//
//  Index.swift
//  GenkitaiSo
//
//  Created by amanda.tavares on 13/02/23.
//

import Foundation

struct Index: Codable, Equatable {
    let row: Int
    let column: Int
}

struct Position: Codable, Equatable {
    let row: Double
    let column: Double
}

struct Move: Codable {
    var from: Position
    var to: Position
}
