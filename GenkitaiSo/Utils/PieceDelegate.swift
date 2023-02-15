//
//  PieceDelegate.swift
//  GenkitaiSo
//
//  Created by amanda.tavares on 13/02/23.
//

import Foundation

// see logic
protocol PieceDelegate: AnyObject {
    //func pieceDidMove(from originIndex: Index, to newIndex: Index)
    func pieceRemoved(from index: Index) // back to be used
}
