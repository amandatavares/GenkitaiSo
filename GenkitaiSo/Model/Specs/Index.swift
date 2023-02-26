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
    let x: Double
    let y: Double
}

struct Move {
    var previousPos: Position
    var newPos: Position
}
