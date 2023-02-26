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
//    var pieces: [Piece] = [] //inside Board
    
    private var selectedNode: SKNode?
    var previousPos: Position?
    var newPos: Position?
    
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
                    self.selectedNode = node
                    self.previousPos = Position(x: node.position.x, y: node.position.y)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let node = self.selectedNode {
            let touchLocation = touch.location(in: self)
            node.position = touchLocation
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //centraliza a peça no meio do espaço
        if let node = self.selectedNode, let touch = touches.first {
            
            //Apartir da posição do node encontra linha e coluna
            let position = touch.location(in: self)
            let column = self.board.tileMap.tileColumnIndex(fromPosition: position)
            let row =  self.board.tileMap.tileRowIndex(fromPosition: position)
            let center = centerTile(atPoint: position)
            
            let nodesInCenter = tileMap.nodes(at: center)
                //se o node estiver fora do tabuleiro 6x6 (0 ate 5)
                if column < 0 || column > 5 || row < 0 || row > 5 {
                    for piece in pieces where piece.node == node {
                        node.position = CGPoint(x: piece.xOrigin, y: piece.yOrigin)
                        self.newPos = Position(x: piece.xOrigin, y: piece.yOrigin)
                    }
                } else {
                    // se existir mais que um node na posição, volta para a posição anterior
                    if nodesInCenter.count > 1 && nodesInCenter.contains(node) {
                        node.position = CGPoint(x: previousPos!.x, y: previousPos!.y)
                        self.newPos = Position(x: previousPos!.x, y: previousPos!.y)
                    } else if nodesInCenter.count >= 1 && !nodesInCenter.contains(node) {
                        node.position = CGPoint(x: previousPos!.x, y: previousPos!.y)
                        self.newPos = Position(x: previousPos!.x, y: previousPos!.y)
                    
                    } else {
                        node.position = center
                        self.newPos = Position(x: center.x, y: center.y)
                    }
                }
            movesPices.append(Move(previousPos: self.previousPos!, newPos: self.newPos!))
        }
        //Finaliza a movimentação do drag and drop
        self.selectedNode = nil
    }
    
}
