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
    var index: Index
    var possibleMoves: [Index] = []
    
    init(color: UIColor, position: CGPoint, index: Index, type: Player) {
        
        self.type = type
        self.index = index
        
        let piece = SKShapeNode(circleOfRadius: 15)
        piece.fillColor = color
        piece.lineWidth = 0
        piece.zPosition = 3
        piece.position = position
        
        let shadow = SKShapeNode(circleOfRadius: 15)
        shadow.fillColor = UIColor(white: 0.1, alpha: 0.2)
        shadow.lineWidth = 0
        shadow.zPosition = 2
        shadow.position = CGPoint(x: position.x - 3, y: position.y - 5)
        
        let node = SKShapeNode()
        node.addChild(shadow)
        node.addChild(piece)
        
        self.node = node
    }
    
    func removeFromBoard() {
        self.node.removeFromParent()
        delegate?.pieceRemoved(from: index)
    }
    
}
