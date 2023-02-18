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
    
    //MARK: - Custom Alert
//    lazy var stateView: UIView = {
////        let view = UIView(frame: self.skView.frame)
////        view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
//        stateView.layer.zPosition = -10
//        return view
//    }()
//
    //MARK: - GameState
//    awaitingConnection
//    var state: GameState! = .yourTurn {
//        didSet {
//            self.stateMessageLabel.text = state.rawValue
//            switch state {
//            case .yourTurn:
//                dismissStateView()
//            default:
////                showStateView()
//                dismissStateView()
//
//            } //uncomment when Socket done
//        }
//    }
    
    //MARK: - State View
//    func showStateView() {
//        self.view.addSubview(stateView)
//    }
//
//    func dismissStateView() {
//        stateView.removeFromSuperview()
//    }
    
    
    //MARK: - GameScene Cast
    var gameScene: GameScene {
        return skView.scene as! GameScene
    }
    
    //MARK: - View Actions
    @IBAction func sendAction(_ sender: UIButton) {
        if playerIsConnected() {
            if let content = self.textField.text, content.replacingOccurrences(of: " ", with: "") != "" {
                socketService.sendMessage(author: socketService.name!, content: content)
                self.textField.text?.removeAll()
                self.view.endEditing(true)
            }
        }
    }
    
    //MARK: - Connection Status Verification
    func playerIsConnected() -> Bool {
        if gameScene.player == .disconnected {
            showAlert(text: "Server is Unavailable", buttonText: "Try Again") { alert in
                self.socketService.socket.connect()
            }
            return false
        }
        return true
    }
    
    func showAlert(text: String, buttonText: String = "OK", handler: @escaping (UIAlertAction) -> Void = { alert in }) {
        let alertController = UIAlertController(title: text, message: "", preferredStyle: .alert)
        alertController.addAction(
            UIAlertAction(title: buttonText, style: .default, handler: handler)
        )
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stateMessageLabel.text = GameState.awaitingConnection.rawValue
        
        self.chatTextView.layoutManager.allowsNonContiguousLayout = false
        self.chatTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: -20, right: 10);
        
        self.textField.delegate = self
        
        socketService.delegate = self
        
        
//             Load the SKScene from 'GameScene.sks'
        if let scene = GKScene(fileNamed: "GameScene") {
            if let sceneNode = scene.rootNode as! GameScene? {
                sceneNode.board.delegate = self
                
                sceneNode.backgroundColor = self.view.backgroundColor!
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                skView.presentScene(sceneNode)
                
                skView.ignoresSiblingOrder = true
                
                skView.showsFPS = true
                skView.showsNodeCount = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        showStateView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override var shouldAutorotate: Bool {
        return true
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
    
    //MARK: - Restart
    func restart() {
        socketService.restart()
        viewDidLoad()
        viewDidAppear(true)
        self.chatTextView.text = "\n"
    }
}


//MARK: - TextFieldDelegate
extension GameViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let offsetY = UIScreen.main.bounds.height/2.55 - textField.frame.origin.y
        UIView.animate(withDuration: 0.25) {
            self.view.layer.position = CGPoint(x: self.view.layer.position.x, y: self.view.layer.position.y - offsetY)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.view.layer.position = CGPoint(x: self.view.layer.position.x, y: UIScreen.main.bounds.height/2)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}


//MARK: - GameDelegate
extension GameViewController: GameDelegate {
    
    func didStart() {
        if gameScene.player == .leftPlayer {
//            state = .yourTurn
            print("Your turn")
        } else {
//            state = .waiting
            print("Waiting")
        }
    }
    
    func newTurn(_ name: String) {
        
//        self.gameScene.board.verifyDeadPieces()
        
        self.gameScene.board.hasMoved = false
        self.gameScene.board.newPos = nil
        self.gameScene.board.previousPos = nil
        
        if name == gameScene.player.rawValue {
//            state = .yourTurn
            print("Your turn")
        } else {
//            state = .waiting //uncomment when socket
            print("Waiting")
        }
    }
    
    func playerDidMove(_ name: String, from originIndex: Index, to newIndex: Index) {
        gameScene.board.movePiece(from: originIndex, to: newIndex)
    }
    
    func didWin() {
        let alert = UIAlertController(title: "You Win", message: "", preferredStyle: .alert)
        let exit = UIAlertAction(title: "Play Again", style: .default, handler: { _ in self.restart() })
        alert.addAction(exit)
        self.present(alert, animated: true, completion: nil)
    }
    
    func didLose() {
        let alert = UIAlertController(title: "You Lose", message: "", preferredStyle: .alert)
        let exit = UIAlertAction(title: "Play Again", style: .default, handler: { _ in self.restart() })
        alert.addAction(exit)
        self.present(alert, animated: true, completion: nil)
    }
    
    func receivedMessage(_ name: String, msg: String) {

        let mutAtt = NSMutableAttributedString(attributedString: chatTextView.attributedText)
        
        let fontBold = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
        let fontNorm = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]

        let attString = NSMutableAttributedString(string: "\(name.capitalized): ", attributes: fontBold)
        attString.append(NSAttributedString(string:"\(msg)\n", attributes: fontNorm))

        
        mutAtt.insert(attString, at: mutAtt.length-1)
        self.chatTextView.attributedText = mutAtt
       
        let stringLength: Int = self.chatTextView.text.count
        let range = NSMakeRange(stringLength-1, 1)
        self.chatTextView.scrollRangeToVisible(range)
    }
    
    func youArePlayingAt(_ team: String) {
        gameScene.player = Player(rawValue: team) ?? .disconnected
        self.playerNameLabel.text = "You are Team "+gameScene.player.rawValue.capitalized
        print("👾 You are player \(gameScene.player.rawValue)")
    }
    
}


extension GameViewController: BoardDelegate {
    
    func gameOver(winner: Player) {
        socketService.gameOver(winner: winner)
    }
    
}
