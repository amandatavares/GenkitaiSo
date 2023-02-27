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
    
    @IBOutlet weak var chatStackView: UIStackView!
    @IBOutlet weak var gameView: UIView!
    
    //MARK: - Socket Service Instatiation
    let socketService: SocketService = SocketService()
    var chat = Chat()

    //MARK: - Custom Alert
    lazy var stateView: UIView = {
        let stateView = UIView(frame: self.skView.frame)
        let label = UILabel()
        label.frame = CGRect(origin: CGPoint(x: stateView.frame.width/2-50, y:  stateView.frame.height/2), size: CGSize(width: 150, height: 20))
        label.text = state.rawValue
        label.textColor = UIColor.white
        label.textAlignment = .center
        stateView.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        stateView.addSubview(label)
        return stateView
    }()

    //MARK: - GameState

    var state: GameState! = .awaitingConnection {
        didSet {
            self.stateMessageLabel.text = state.rawValue
            switch state {
            case .yourTurn:
                dismissStateView()
            default:
                showStateView()
            }
        }
    }
    
    //MARK: - State View
    func showStateView() {
        self.view.addSubview(stateView)
    }

    func dismissStateView() {
        stateView.removeFromSuperview()
    }
    
    
    //MARK: - GameScene Cast
    var gameScene: GameScene {
        return skView.scene as! GameScene
    }
    
    //MARK: - View Actions
    @IBAction func sendAction(_ sender: UIButton) {
//        if playerIsConnected() {
        socketService.sendMessage(author: self.gameScene.player.rawValue, content: self.textField.text ?? "?")
        self.textField.text?.removeAll()
        self.view.endEditing(true)
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
      
        self.customizeViews()
        
        self.chatTableView.dataSource = self
        self.chatTableView.delegate = self
        
        self.socketService.delegate = self
        
        self.textField.delegate = self
        
//             Load the SKScene from 'GameScene.sks'
        if let scene = GKScene(fileNamed: "GameScene") {
            if let sceneNode = scene.rootNode as! GameScene? {
                sceneNode.board.delegate = self
                
                sceneNode.backgroundColor = UIColor.Game.gameBackground
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                skView.presentScene(sceneNode)
                
                skView.ignoresSiblingOrder = true
                skView.showsFPS = true
                skView.showsNodeCount = true
            }
        }

        self.gameScene.board.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        for move in gameScene.board.currentMoves {
            self.socketService.move(from: move.previousPos, to: move.newPos)
        }
        self.socketService.newTurn()
    }
    
    @IBAction func didGaveUp(_ sender: Any) {
        print("clicked give up")
        showAlert(text: "Are you sure you want to give up?", buttonText: "Yes") { alert in
            self.socketService.giveUp(player: self.gameScene.player.rawValue)
            self.didLose()
//            self.restart()
        }
    }
    
    //MARK: - Restart
    func restart() {
        socketService.restart()
        viewDidLoad()
        viewDidAppear(true)
    }
    
    func customizeViews() {
        
        self.chatStackView.layer.cornerRadius = 20
        self.gameView.layer.cornerRadius = 20
        self.view.backgroundColor = UIColor.Game.background
        self.textField.backgroundColor = UIColor.Game.background
        
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
        
        let date = self.chat.messages[indexPath.row].timestamp
        if let index = (date.range(of: ",")?.upperBound) {
            let time = String(date.suffix(from: index))
            cell.timeLabel.text = time
        } else {
            cell.timeLabel.text = self.chat.messages[indexPath.row].timestamp
        }

        return cell
    }
    
    
}

//MARK: - GameDelegate
extension GameViewController: GameDelegate {
    
    func didStart() {
        if self.gameScene.player == .playerBottom {
            state = .yourTurn
            print("Your turn")
        } else {
            state = .waiting
            print("Waiting")
        }
    }
    
    func newTurn(_ name: String) {
        self.gameScene.board.newPos = nil
        self.gameScene.board.previousPos = nil
        self.gameScene.board.currentMoves = []
        
        if name == gameScene.player.rawValue {
            state = .waiting
            print("Waiting")
        } else {
            state = .yourTurn
            print("Your turn")
        }
    }
    
    func playerDidMove(_ name: String, from origin: Position, to new: Position) {
        print("Se mexeu aí \(origin) para \(new)")
        gameScene.board.movePiece(from: origin, to: new)
    }
    
    func didWin() {

    }

    // feels wrong
    func didLose() {
        state = GameState.youLose
        let loseView = UIView(frame: self.skView.frame)
        let label = UILabel()
        label.frame = CGRect(origin: CGPoint(x: loseView.frame.width/2-50, y:  loseView.frame.height/2), size: CGSize(width: 150, height: 20))
        label.text = state.rawValue
        label.textColor = UIColor.white
        label.textAlignment = .center
        loseView.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        loseView.addSubview(label)
        self.view.addSubview(loseView)
    }
//
    func receivedMessage(name: String, msg: String, hour: String) {
        self.chat.messages.append(Message(timestamp: hour, author: name, content: msg))
        self.chatTableView.reloadData()
    }
    
    func youArePlayingAt(_ team: String) {
        self.gameScene.player = Player(rawValue: team) ?? .disconnected
        
        self.playerNameLabel.text = "You are  "+gameScene.player.rawValue.capitalized
        print("👾 You are player \(gameScene.player.rawValue)")
    }
    
}

extension GameViewController: BoardDelegate {
    
    func gameOver(winner: Player) {
        socketService.gameOver(winner: winner)
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
