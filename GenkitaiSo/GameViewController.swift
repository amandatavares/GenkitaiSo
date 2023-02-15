//
//  GameViewController.swift
//  GenkitaiSo
//
//  Created by amanda.tavares on 13/02/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    //MARK: - View Outlets
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var stateMessageLabel: UILabel!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    //MARK: - Socket Service Instatiation
    let socketService: SocketService = SocketService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
