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
        piece.position = CGPoint(x: index.x, y: index.y)
        piece.name = "piece"
        
        if type == .playerBottom {
            piece.fillColor = UIColor.PieceColor.bottom //dark
        } else {
            piece.fillColor = UIColor.PieceColor.top //yellow
        }
        
//        // Add shadow
//        let shadow = SKShapeNode(circleOfRadius: 20)
//        shadow.fillColor = UIColor(white: 0.1, alpha: 0.2)
//        shadow.lineWidth = 0
//        shadow.position = CGPoint(x: index.x + 3, y: index.y - 5)
//
//        let node = SKShapeNode()
//        node.addChild(shadow)
//        node.addChild(piece)
        
        self.node = piece
        
    }
    
    func remove(from origin: Piece) {
        origin.node.removeFromParent()
//        guard let pieceIndex = pieces.firstIndex(of: origin) else { return }
//        pieces.remove(at: pieceIndex)
//        delegate?.pieceRemoved(from: pieceIndex)
    }
    

}
