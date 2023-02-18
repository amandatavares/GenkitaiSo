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
    
    private var square: SKShapeNode!
    var tileSet: SKTileSet!
    var tileMap: SKTileMapNode!
    
    private var currentNode: SKNode?
    
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
        
    }
    
    func setup(numberOfRows: Int) {
        let whiteTexture = SKTexture(imageNamed: "tile")
        
        let whiteTile = SKTileDefinition(texture: whiteTexture)
        let whiteTileGroup = SKTileGroup(tileDefinition: whiteTile)
        
        tileSet = SKTileSet(tileGroups: [whiteTileGroup], tileSetType: .grid)
        
//        let tileSize = tileSet.defaultTileSize // from image size

        let tileSize = CGSize(width: 100, height: 100)
        
        tileMap = SKTileMapNode(tileSet: tileSet, columns: numberOfRows, rows: numberOfRows, tileSize: tileSize)
        let tileGroup = tileSet.tileGroups.first
        tileMap.fill(with: tileGroup) // fill or set by column/row
        tileMap.anchorPoint = .zero
                
//        self.addChild(tileMap)
    }
    
    func getSquare(atScreenPoint point: CGPoint) -> SquareState? {
        for (indexRow, row) in rowsNodes.enumerated() {
            for (indexColumn, squareNode) in row.enumerated() {
                let squareData = rowsData[indexRow][indexColumn]
                if squareNode.contains(point) { return squareData }
            }
        }
        return nil
    }
    
    func getPiece(at index: Index) -> Piece? {
        return pieces.filter { $0.index == index }.first
    }
    

//    func turnOnMasks(for moves: [Square?], at piece: Piece) {
//        moves.forEach {
//            if let tile = $0 {
//                if tile.data.isEmpty {
//                    createMoveMask(square: tile)
//                    piece.possibleMoves.append(tile.data.index)
//                }
//            }
//        }
//    }
//
//    func createMoveMask(square: Square) {
//        let mask = square.node.copy() as! SKShapeNode
//        mask.lineWidth = 5
//        mask.strokeColor = Colors.highlightStroke.color
//        mask.fillColor = Colors.highlight.color
//        self.node.addChild(mask)
//    }
    
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
//        
    }
    
}


extension Board: PieceDelegate {
    func pieceRemoved(from index: Index) {
        pieces = pieces.filter { $0.index != index }
        getSquare(at: index)?.data.setEmpty()
    }
}
