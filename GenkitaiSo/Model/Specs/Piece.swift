//
//  Piece.swift
//  GenkitaiSo
//
//  Created by amanda.tavares on 13/02/23.
//

import Foundation
import SpriteKit

class Piece {
    weak var delegate: PieceDelegate?
    
    var node: SKShapeNode
    let type: Player
    var index: Position
    var initialPosition: [Position] = []
    
    init(index: Position, type: Player) {
        
        // Piece definition
        self.type = type
        self.index = index
        
        // Customize piece
        let piece = SKShapeNode(circleOfRadius: 20)
        piece.position = CGPoint(x: index.row, y: index.column)
        piece.name = "piece"
        
        if type == .playerBottom {
            piece.fillColor = UIColor.PieceColor.bottom //dark
        } else {
            piece.fillColor = UIColor.PieceColor.top //yellow
        }
        
        self.node = piece
        
    }
    
    func remove(from origin: Piece) {
        origin.node.removeFromParent()
//        guard let pieceIndex = pieces.firstIndex(of: origin) else { return }
//        pieces.remove(at: pieceIndex)
//        delegate?.pieceRemoved(from: pieceIndex)
    }
    

}
