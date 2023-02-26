//
//  Board.swift
//  GenkitaiSo
//
//  Created by amanda.tavares on 13/02/23.
//

import Foundation
import SpriteKit

struct Square {
    let node: SKShapeNode
    let data: SquareState
}

class Board {
    
    weak var delegate: BoardDelegate!
    
    var tileSet: SKTileSet!
    var tileMap: SKTileMapNode!
    
//    private var currentNode: SKNode?
    
    var pieces: [Piece] = []
    var currentMoves: [Move] = [] //movePieces
    
    var originTopPositions: [Position] = []
    var originBottomPositions: [Position] = []
    
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
    

    func getSquare(at index: Position) -> Square? {
//        if index.row >= 0, index.column >= 0, index.row < rowsNodes.count, index.column < rowsNodes[index.row].count {
//            return Square(node: rowsNodes[index.row][index.column], data: rowsData[index.row][index.column])
//        }
        print("reform")
        return nil
    }
    

    init(numberOfRows x: Int) {
        setup(numberOfRows: x)
        setupInitialPieces()
    }
    
    func setup(numberOfRows: Int) {
        let texture = SKTexture(imageNamed: "tile")
        
        let tile = SKTileDefinition(texture: texture)
        let tileGroup = SKTileGroup(tileDefinition: tile)
        
        tileSet = SKTileSet(tileGroups: [tileGroup], tileSetType: .grid)
        
        let tileSize = tileSet.defaultTileSize // from image size

//        let tileSize = CGSize(width: 30, height: 30)
        
        tileMap = SKTileMapNode(tileSet: tileSet, columns: numberOfRows, rows: numberOfRows, tileSize: tileSize)
        
        let boardTileGroup = tileSet.tileGroups.first
        tileMap.fill(with: boardTileGroup) // fill or set by column/row
        tileMap.anchorPoint = .init(x: -0.23, y: -0.33)
//        change position here!!!

    }
    
    func setupInitialPieces() {
        self.originTopPositions = [Position(x: 140.0, y: 120.0),
                                 Position(x: 200.0, y: 120.0),
                                 Position(x: 260.0, y: 120.0),
                                 Position(x: 320.0, y: 120.0),
                                 Position(x: 380.0, y: 120.0),
                                 Position(x: 440.0, y: 120.0),
                                 Position(x: 500.0, y: 120.0),
                                 Position(x: 560.0, y: 120.0)]
        
        self.originBottomPositions = [Position(x: 140.0, y: 680.0),
                               Position(x: 200.0, y: 680.0),
                               Position(x: 260.0, y: 680.0),
                               Position(x: 320.0, y: 680.0),
                               Position(x: 380.0, y: 680.0),
                               Position(x: 440.0, y: 680.0),
                               Position(x: 500.0, y: 680.0),
                               Position(x: 560.0, y: 680.0)]
        
        for top in self.originTopPositions {
            let piece = Piece(index: Position(x: top.x, y: top.y), type: .playerTop)
            self.pieces.append(piece)
        }
        
        for bottom in self.originBottomPositions {
            let piece = Piece(index: Position(x: bottom.x, y: bottom.y), type: .playerBottom)
            self.pieces.append(piece)
        }
    }
    
//    func getPiece(at index: Position) -> Piece? {
//        return pieces.filter { $0.index == index }.first
//    }
    
//    func verifyDeadPieces() {}
    
}

extension Board: SquareStateDelegate {
    func didSelect(index: Index) {
        
    }
    func didUnselect(index: Index) {
//        
    }
    
}


extension Board: PieceDelegate {
    func pieceRemoved(from index: Position) {
        pieces = pieces.filter { $0.index != index }
    }
}
