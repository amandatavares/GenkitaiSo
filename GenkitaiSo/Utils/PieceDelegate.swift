//
//  PieceDelegate.swift
//  GenkitaiSo
//
//  Created by amanda.tavares on 13/02/23.
//

import Foundation

// see logic
protocol PieceDelegate: AnyObject {
    func pieceRemoved(from index: Position) // back to be used
}
