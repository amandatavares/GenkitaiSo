//
//  Board.swift
//  GenkitaiSo
//
//  Created by amanda.tavares on 13/02/23.
//

import Foundation
import SpriteKit

//MARK: Refactor: build structs for:
/*
 - Row
 - Square / Tile
 - position (x,y)
 - isEmpty -> Bool
 - hasPiece -> Bool
 
 - Piece
 - moveTo(1,2,3,4,5,6,7,8) -> Bool
 - outBoard() -> Bool
 
 - Kernel
 - 6x6
 - availableMoves() -> [1,2,3,4,5,6,7,8]
 - How to deal with borders?
 */

struct Square {
    let node: SKShapeNode
    let data: SquareState
}

class Board {
    
    weak var delegate: BoardDelegate!
    
    private(set) var node: SKNode = SKNode()
    private var rowsNodes : [[SKShapeNode]] = []
    private var rowsData: [[SquareState]] = []
    
    private var pieces: [Piece] = []
//    REDO: gameover logic
//    var amountDeadTop: Int = 0 {
//        didSet {
//            if amountDeadTop > 1 {
//                delegate.gameOver(winner: .pointBottom)
//            }
//        }
//    }
//    var amountDeadBottom: Int = 0 {
//        didSet {
//            if amountDeadBottom > 1 {
//                delegate.gameOver(winner: .pointTop)
//            }
//        }
//    }
    
    var hasMoved: Bool = false
    var previousPos: Index?
    var newPos: Index?
    
    func squareDatas(of type: Player) -> [[SquareState]] {
        return rowsData.compactMap { row in row.filter{ $0.type == type } }
    }
    
    func getSelectedSquare() -> Square? {
        for (indexRow, row) in rowsNodes.enumerated() {
            for (indexColumn, squareNode) in row.enumerated() {
                let squareData = rowsData[indexRow][indexColumn]
                squareData.delegate = self
                if squareData.isSelected {
                    return Square(node: squareNode, data: squareData)
                }
            }
        }
        return nil
    }
    
    func getSquare(at index: Index) -> Square? {
        if index.row >= 0, index.column >= 0, index.row < rowsNodes.count, index.column < rowsNodes[index.row].count {
            return Square(node: rowsNodes[index.row][index.column], data: rowsData[index.row][index.column])
        }
        return nil
    }
    
    private let scale: CGFloat
    private let originY: CGFloat
    
    init(amountOfRows x: Int, scale: CGFloat, originY: CGFloat) {
        
        self.scale = scale
        self.originY = originY
        
        setup(numberOfRows: x)
        
        rowsNodes.flatMap{ $0 }.forEach { self.node.addChild($0) }
        
        placePieces()
    }
    
    private func placePieces() {}
    private func placePiece(at square: SquareState, captain: Bool = false) {}
    func setup(numberOfRows: Int) {}
    func createRow(number i: Int, amountOfElements e: Int, backoff: Int, beginsWithReversed: Bool = false) {}
    func getSquare(atScreenPoint point: CGPoint) -> SquareState? {}
    func getPiece(at index: Index) -> Piece? {}
//    func turnOnMasks(for moves: [Square?], at piece: Piece) {}
//    func createMoveMask(square: Square) {}
    func movePiece(from originIndex: Index, to newIndex: Index) {}
//    func verifyDeadPieces() {}
    
}

extension Board: SquareStateDelegate {
    func didSelect(index: Index) {
        
//        node.children.forEach {
//            if ($0 as! SKShapeNode).fillColor.description == Colors.highlight.color.description {
//                $0.removeFromParent()
//            }
//        }
//
//        guard let square: Square = getSquare(at: index) else { return }
//        guard let piece = getPiece(at: index) else { return }
    }
    
    func didUnselect(index: Index) {
        <#code#>
    }
    
}


extension Board: PieceDelegate {
    func pieceRemoved(from index: Index) {
        pieces = pieces.filter { $0.index != index }
        getSquare(at: index)?.data.setEmpty()
    }
}
