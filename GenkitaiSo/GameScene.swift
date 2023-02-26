//
//  GameScene.swift
//  GenkitaiSo
//
//  Created by amanda.tavares on 13/02/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var lastUpdateTime : TimeInterval = 0

    var board: Board!
    var player: Player = .disconnected
    var pieces: [Piece] = []
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        //Setup Board
        self.board = Board(amountOfRows: 6, scale: 33, originY: 333)
        self.addChild(board.tileMap)
        print(board.tileMap.anchorPoint)
        print(board.tileMap.position)
        print(board.tileMap.mapSize)
    }
    
    func touchDown(atPoint point: CGPoint) {
        
//        if player == .disconnected {
//            return
//        }
        
        // David's code to touch
//        //get triangle at touch point
//        guard let touchedTriangleData = board.getTriangle(atScreenPoint: point) else { return }
//
//        if player == touchedTriangleData.type {
//            //verify if there is any piece selected
//            if let selectedTriangle = board.getSelectedTriangle(),
//                let pieceAtSelectedTriangle = board.getPiece(at: selectedTriangle.data.index) {
//
//                //verify if touch was in possibleMoves
//                if pieceAtSelectedTriangle.possibleMoves.contains(touchedTriangleData.index) {
//                    board.movePiece(from: pieceAtSelectedTriangle.index, to: touchedTriangleData.index)
//                } else {
//                    selectedTriangle.data.deselect()
//                }
//
//            } else {
//                // No selected triangle, select it!
//                if touchedTriangleData.hasPiece {
//                    touchedTriangleData.select()
//                }
//            }
//
//        }
        
    }
    
    func touchUp(atPoint point: CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        
//        //centraliza a peça no meio do espaço
//        if let node = self.currentNode, let touch = touches.first {
//            
//            let position = touch.location(in: self)
//            let column = tileMap.tileColumnIndex(fromPosition: position)
//            let row = tileMap.tileRowIndex(fromPosition: position)
//            
//            if column < 0 || column > 5 || row < 0 || row > 5 {
//                for piece in pieces where piece.node == node {
//                    node.position = CGPoint(x: piece.xOrigin, y: piece.yOrigin)
//                    self.newPos = PositionPiece(x: piece.xOrigin, y: piece.yOrigin)
//                }
//            } else {
//                let center = centerTile(atPoint: position)
//                node.position = center
//                self.newPos = PositionPiece(x: center.x, y: center.y)
//                
//                
//            }
//            
//            
//            for i in pieces.indices {
//                if pieces[i].node == node {
//                    pieces[i].currentPosition.append(Move(previousPos: self.previousPos!, newPos: self.newPos!))
//                }
//            }
//            
//            
//        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    
}
