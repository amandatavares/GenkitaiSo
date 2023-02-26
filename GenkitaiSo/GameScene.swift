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

    var board: Board!
    var player: Player = .disconnected

    override func sceneDidLoad() {
        
        //Setup Board
        self.board = Board(numberOfRows: 6)
        self.addChild(board.tileMap)
        print(board.tileMap.anchorPoint)
        print(board.tileMap.position)
        print(board.tileMap.mapSize)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let touchedNodes = self.nodes(at: location)
            for node in touchedNodes.reversed() {
                if node.name == "piece" {
                    self.board.selectedNode = node
                    self.board.previousPos = Position(x: node.position.x, y: node.position.y)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let node = self.board.selectedNode {
            let touchLocation = touch.location(in: self)
            node.position = touchLocation
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //centraliza a peça no meio do espaço
        if let node = self.board.selectedNode, let touch = touches.first {
            
            //Apartir da posição do node encontra linha e coluna
            let position = touch.location(in: self)
            self.board.centerPiece(node: node, at: position)
        }
        //Finaliza a movimentação do drag and drop
        self.board.selectedNode = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.board.selectedNode = nil
    }
    
    
}
