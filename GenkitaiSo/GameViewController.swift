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
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var giveUpButton: UIButton!
    
    //MARK: - Socket Service Instatiation
    let socketService: SocketService = SocketService()
    var chat = Chat()

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
//        if playerIsConnected() {
//        if let content = self.textField.text, content.replacingOccurrences(of: " ", with: "") != "" {
        socketService.sendMessage(author: "fodida", content: self.textField.text ?? "?")
        self.textField.text?.removeAll()
        self.view.endEditing(true)
//        }
//        }
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
        
        let image = UIImage(systemName: "flag.fill")
        self.giveUpButton.imageView?.image = image
        
        self.chatTableView.dataSource = self
        self.chatTableView.delegate = self
        self.socketService.delegate = self
        self.textField.delegate = self
        
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
    
    @IBAction func didFinishedTurn(_ sender: Any) {
        print("clicked finish turn")
//        for piece in gameScene.pieces {
//            var move = piece.currentPosition
//            self.socketService.move(from: move[0].previous, to: move[0].new)
//        }
//        for move in gameScene.movePices {
//            self.service.move(from: move.previousPos, to: move.newPos)
//        }
    }
    
    @IBAction func didGaveUp(_ sender: Any) {
        print("clicked give up")
        showAlert(text: "Are you sure you want to give up?", buttonText: "Yes") { alert in
            self.restart()
        }
        
    }
    
    //MARK: - Restart
    func restart() {
        socketService.restart()
        viewDidLoad()
        viewDidAppear(true)
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


//MARK: - TableViewDelegate
extension GameViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chat.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatTableViewCell
        cell.nameLabel.text = self.chat.messages[indexPath.row].author
        cell.messageLabel.text = self.chat.messages[indexPath.row].content
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
//        dateFormatter.locale = Locale(identifier: "pt_BR")
//        let serverTime = dateFormatter.date(from:self.chat.messages[indexPath.row].timestamp)!
//        let time = dateFormatter.string(from: timestamp)

        cell.timeLabel.text = self.chat.messages[indexPath.row].timestamp
        return cell
    }
    
    
}

//MARK: - GameDelegate
extension GameViewController: GameDelegate {
    
    func didStart() {
        if gameScene.player == .playerTop {
//            state = .yourTurn
            print("Your turn")
        } else {
//            state = .waiting
            print("Waiting")
        }
    }
    
    func newTurn(_ name: String) {
        
//        self.gameScene.board.verifyDeadPieces()
        
//        self.gameScene.board.hasMoved = false
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
    
    func playerDidMove(_ name: String, from origin: Position, to new: Position) {
        print("Se mexeu aí \(origin) para \(new)")
        gameScene.board.movePiece(from: origin, to: new)
    }
    
    func didWin() {

    }
//
    func didLose() {

    }
//
    func receivedMessage(name: String, msg: String, hour: String) {
        self.chat.messages.append(Message(timestamp: hour, author: name, content: msg))
        self.chatTableView.reloadData()
    }
    
    func youArePlayingAt(_ team: String) {
        gameScene.player = Player(rawValue: team) ?? .disconnected
        
        self.playerNameLabel.text = "You are  "+gameScene.player.rawValue.capitalized
        print("👾 You are player \(gameScene.player.rawValue)")
    }
    
}

extension GameViewController: BoardDelegate {
    
    func gameOver(winner: Player) {
        socketService.gameOver(winner: winner)
    }
    
}
