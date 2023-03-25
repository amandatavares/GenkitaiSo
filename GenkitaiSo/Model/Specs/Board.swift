//
//  Board.swift
//  GenkitaiSo
//
//  Created by amanda.tavares on 13/02/23.
//

import Foundation
import SpriteKit

class Board {
    
    weak var delegate: BoardDelegate!
    
    var tileSet: SKTileSet!
    var tileMap: SKTileMapNode!
    var numberOfRows = 0
    var numberOfPieces = 8
    
    // private var currentNode: SKNode?
    
    var pieces: [Piece] = []
    var currentMoves: [Move] = [] //movePieces
    
    var originTopPositions: [Position] = []
    var originBottomPositions: [Position] = []
    
    var selectedNode: SKNode?
    var previousPos: Position?
    var newPos: Position?
    

    init(numberOfRows x: Int) {
        setup(numberOfRows: x)
        setupInitialPieces()
    }
    
    func setup(numberOfRows: Int) {
        self.numberOfRows = numberOfRows
        let texture = SKTexture(imageNamed: "tile")
        
        let tile = SKTileDefinition(texture: texture)
        let tileGroup = SKTileGroup(tileDefinition: tile)
        
        tileSet = SKTileSet(tileGroups: [tileGroup], tileSetType: .grid)
        
        let tileSize = CGSize(width: tileSet.defaultTileSize.width+5, height: tileSet.defaultTileSize.height+5) // from image size

        tileMap = SKTileMapNode(tileSet: tileSet, columns: numberOfRows, rows: numberOfRows, tileSize: tileSize)
        
        let boardTileGroup = tileSet.tileGroups.first
        tileMap.fill(with: boardTileGroup) // fill or set by column/row
        tileMap.anchorPoint = .init(x: -0.22, y: -0.85)

    }
    
    func setupInitialPieces() {
        let piecePlace = 40.0
        let inset = 60.0
        
        // Set board place
        let boardSize = self.tileMap.frame.size
        let topY = (boardSize.height*2)-piecePlace
        let bottomY = boardSize.height-(3*piecePlace)
        
        // Set pieces positions
        for i in 0..<numberOfPieces {
            let topPosition = Position(row: 150.0+(inset*Double(i)), column: topY)
            print(topPosition)
            self.originTopPositions.append(topPosition)
            
            let bottomPosition = Position(row: 150.0+(inset*Double(i)), column: bottomY)
            print(bottomPosition)
            self.originBottomPositions.append(bottomPosition)

        }
        
        // Place pieces 
        for top in self.originTopPositions {
            print(top)
            let piece = Piece(index: Position(row: top.row, column: top.column), type: .playerTop)
            self.tileMap.addChild(piece.node)
            self.pieces.append(piece)
        }
        
        for bottom in self.originBottomPositions {
            print(bottom)
            let piece = Piece(index: Position(row: bottom.row, column: bottom.column), type: .playerBottom)
            self.tileMap.addChild(piece.node)
            self.pieces.append(piece)
        }
    }
    
    func getCenterTile(atPoint pos: CGPoint) -> CGPoint {
        let axis = getAxisTile(atPoint: pos)
        let center = self.tileMap.centerOfTile(atColumn: axis.0, row: axis.1)
        return center
    }
    
    func getAxisTile(atPoint pos: CGPoint) -> (Int, Int) {
        let column = self.tileMap.tileColumnIndex(fromPosition: pos)
        let row = self.tileMap.tileRowIndex(fromPosition: pos)
        return (column: column, row: row)
    }
    
    func findPiece(from pos: Position) -> Piece? { 
        for piece in pieces where piece.node.position.x == pos.row && piece.node.position.y == pos.column {
            return piece
        }
        return nil
    }
    
    func movePiece(from origin: Position, to new: Position) {
        if let piece = findPiece(from: origin) {
            piece.node.position = CGPoint(x: new.row, y: new.column)
        }
    }
    
    func centerPiece(node: SKNode, at pos: CGPoint) {
        let column = self.getAxisTile(atPoint: pos).0
        let row =  self.getAxisTile(atPoint: pos).1
        let center = self.getCenterTile(atPoint: pos)
        
        let nodesInCenter = tileMap.nodes(at: center)
            //se o node estiver fora do tabuleiro 6x6 (0 ate 5)
        if column < 0 || column > self.numberOfRows-1 || row < 0 || row > self.numberOfRows-1 {
                for piece in pieces where piece.node == node {
                    node.position = CGPoint(x: piece.index.row, y: piece.index.column)
                    self.newPos = Position(row: piece.index.row, column: piece.index.column)
                }
            } else {
                // se existir mais que um node na posição, volta para a posição anterior
                if nodesInCenter.count > 1 && nodesInCenter.contains(node) {
                    node.position = CGPoint(x: previousPos!.row, y: previousPos!.column)
                    self.newPos = Position(row: previousPos!.row, column: previousPos!.column)
                } else if nodesInCenter.count >= 1 && !nodesInCenter.contains(node) {
                    node.position = CGPoint(x: previousPos!.row, y: previousPos!.column)
                    self.newPos = Position(row: previousPos!.row, column: previousPos!.column)
                
                } else {
                    node.position = center
                    self.newPos = Position(row: center.x, column: center.y)
                }
            }
        self.currentMoves.append(Move(from: self.previousPos!, to: self.newPos!))
    }

    
}

extension Board: PieceDelegate {
    func pieceRemoved(from index: Position) {
        pieces = pieces.filter { $0.index != index }
    }
}
