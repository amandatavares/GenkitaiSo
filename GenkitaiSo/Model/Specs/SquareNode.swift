//
//  SquareNode.swift
//  GenkitaiSo
//
//  Created by amanda.tavares on 15/02/23.
//

import Foundation
import SpriteKit
import UIKit

extension SKShapeNode {
    static func square(reversed: Bool = false,
                         multiplier: CGFloat = 1.0,
                         xoffset: CGFloat = 0.0,
                         yoffset: CGFloat = 0.0,
                         yOrigin: CGFloat,
                         scale: CGFloat) -> SKShapeNode {
        
//        let fillColor: UIColor = reversed ? Colors.squarePointDown.color : Colors.squarePointUp.color
        
        let path = UIBezierPath()
        
        let square = self.init(path: path.cgPath)
        square.lineWidth = 0
//        square.fillColor = fillColor
        
        return square
    }
}
