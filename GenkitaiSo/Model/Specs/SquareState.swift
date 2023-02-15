//
//  SquareState.swift
//  GenkitaiSo
//
//  Created by amanda.tavares on 15/02/23.
//

import Foundation
import UIKit

class SquareState {
    
    weak var delegate: SquareStateDelegate!
    let index: Index
    let type: Player
    let bgColor: UIColor!
    let pieceColor: UIColor!
    
    private enum CodingKeys: String, CodingKey {
        case position
    }
    
    init(position: Index, type: Player, colorHandler: @escaping (UIColor) -> Void) {
        self.index = position
        self.type = type
        self.setColorHandler = colorHandler
        
        if type == .leftPlayer {
            self.bgColor = .white
            self.pieceColor = .red
        } else {
            self.bgColor = .black
            self.pieceColor = .blue
        }
    }
    
    private(set) var isEmpty: Bool = true {
        didSet {
            if isEmpty {
                hasPiece = false
                hasCaptain = false
                isSelected = false
            }
        }
    }
    
    private(set) var isSelected: Bool = false {
        didSet {
            if isSelected { delegate.didSelect(index: self.index) }
            else { delegate.didUnselect(index: self.index) }
        }
    }
    
    private(set) var hasPiece: Bool = false {
        didSet {
            if hasPiece {
                isEmpty = false
                hasCaptain = false
            }
        }
    }
    
    private(set) var hasCaptain: Bool = false {
        didSet {
            if hasCaptain {
                isEmpty = false
                hasPiece = false
            }
        }
    }
    
    var setColorHandler: ((UIColor) -> Void)?
    
    func setPiece() {
        self.hasPiece = true
        //setColorHandler?(pieceColor)
        //delegate.didSetPiece(triangle: self)
    }
    
    func setEmpty() {
        self.isEmpty = true
        setColorHandler?(bgColor)
    }
    
    func select() {
        self.isSelected = true
    }
    
    func deselect() {
        self.isSelected = false
    }
    
}


