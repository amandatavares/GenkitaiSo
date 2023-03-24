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
    
    
    var chat = Chat() //Chat keep the messages

    //MARK: - State View Alert
    // When it's opponent's turn, we show this alert
    lazy var stateView: StateView = {
        let stateView = StateView(frame: self.gameView.frame)
        stateView.label.text = state.rawValue
        return stateView
    }()

    //MARK: - Define GameState

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
    
    //MARK: - State View Functions
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
    
    // Action: Send message by socket
    @IBAction func sendAction(_ sender: UIButton) {

//        socketService.sendMessage(author: self.gameScene.player.rawValue, content: self.textField.text ?? "?")
        
        guard let text = textfield.text else { return }
        if text != "" {
            let message = message(sender: player.rawValue, content: text)
            RPCManager.shared.client.send(message) { _ in
                self.chat.messages.append(message)
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            }
            //service.enviaMensagem(nome: player.rawValue, mensagem: mensagem)
            //rpcManager.client.(nome: player.rawValue, mensagem: mensagem)
            self.textfield.text?.removeAll()
        }
        
        self.view.endEditing(true)

    }
    
    // Action: Send moves and define turn through socket
    @IBAction func didFinishedTurn(_ sender: Any) {
        print("clicked finish turn")
        for move in gameScene.board.currentMoves {
            //self.grpcClient.move(from: move.previousPos, to: move.newPos)
            RPCManager.shared.client.send(move) { _ in
            }
        }
        //self.service.newTurn()
        self.gameScene.newPos = nil
        self.gameScene.previousPos = nil
        self.gameScene.movesPices = []
        state = .waiting
    }
    
    // Action : User gave up
    @IBAction func didGaveUp(_ sender: Any) {
        print("clicked give up")
        showAlert(text: "Are you sure you want to give up?", buttonText: "Yes") { alert in
//            self.socketService.giveUp(player: self.gameScene.player.rawValue)
            
            // TODO: Add finish game / game over
            self.didLose() //should be instantiate as delegate
            self.restart()
//            self.restart()
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
    
    func showAlert(text: String, buttonText: String = "Yes", handler: @escaping (UIAlertAction) -> Void = { alert in }) {
        let alertController = UIAlertController(title: text, message: "", preferredStyle: .alert)
        alertController.addAction(
            UIAlertAction(title: buttonText, style: .default, handler: handler)
        )
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in alertController.dismiss(animated: true) })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if gameScene.user == 0 {
            player = .playerBottom
        } else if user == 1 {
            gameScene.player = .playerTop
        }
        
        self.stateMessageLabel.text = GameState.awaitingConnection.rawValue
      
        self.customizeViews()
        
        self.chatTableView.dataSource = self
        self.chatTableView.delegate = self
        
        self.textField.delegate = self
        
        // Load the SKScene from 'GameScene.sks'
        if let scene = GKScene(fileNamed: "GameScene") {
            if let sceneNode = scene.rootNode as! GameScene? {
                sceneNode.board.delegate = self
                
                sceneNode.backgroundColor = UIColor.Game.gameBackground
                sceneNode.scaleMode = .aspectFill
                
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
        showStateView()
        
        RPCManager.shared.onMessage { (message) in
            self.chat.messages.append(message)
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
        
        RPCManager.shared.onMove {
            self.gameScene.movePiece(originPos: $0.from, newPos: $0.to)
            self.state = .yourTurn
            
        }
        
        RPCManager.shared.onRestart {
            DispatchQueue.main.async {
                let join = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "roomIdentify")
                join.view.frame = self.view.bounds
                self.view.addSubview(join.view)
                UIView.transition(from: self.view, to: join.view, duration: 0.25, options: .transitionCrossDissolve) { _ in
                    join.didMove(toParent: self)
                }
            }
        }
        
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
        //service.restart()
        //grpcClient.restart()
        RPCManager.shared.client.restart{ _ in }
        
        DispatchQueue.main.async {
            let join = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "roomIdentify")
            join.view.frame = self.view.bounds
            self.view.addSubview(join.view)
            UIView.transition(from: self.view, to: join.view, duration: 0.25, options: .transitionCrossDissolve) { _ in
                join.didMove(toParent: self)
            }
        }
    }
    
    func customizeViews() {
        
        self.chatStackView.layer.cornerRadius = 10
        self.gameView.layer.cornerRadius = 10
        self.skView.layer.cornerRadius = 10
        
        self.view.backgroundColor = UIColor.Game.background
        self.textField.backgroundColor = UIColor.Game.background
        self.chatTableView.separatorColor = UIColor.systemGray6
        
        self.textField.layer.borderColor = UIColor.Game.background.cgColor
    }
}

//MARK: - TableViewDelegate
extension GameViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chat.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatTableViewCell
        
        if self.chat.messages[indexPath.row].sender == "playerBottom" {
            cell.nameLabel.text = "Player Bottom"
        } else {
            cell.nameLabel.text = "Player Top"
        }
        
//        cell.nameLabel.text = self.chat.messages[indexPath.row].author
        cell.messageLabel.text = self.chat.messages[indexPath.row].content
        cell.timeLabel.text = self.chat.messages[indexPath.row].timestamp
        
//        let date = self.chat.messages[indexPath.row].timestamp
//        if let index = (date.range(of: ",")?.upperBound) {
//            let time = String(date.suffix(from: index))
//            cell.timeLabel.text = time
//        } else {
//            cell.timeLabel.text = self.chat.messages[indexPath.row].timestamp
//        }

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
        print("Did move from \(origin) to \(new)")
        gameScene.board.movePiece(from: origin, to: new)
    }
    
    func didWin() {
        self.chat.messages.removeAll()
        state = GameState.youWin
        self.stateView.removeFromSuperview()
        self.stateView.label.text = state.rawValue
        self.view.addSubview(self.stateView)
        
        let alert = UIAlertController(title: "You won! 🎉", message: "", preferredStyle: .alert)
        let exit = UIAlertAction(title: "Play again", style: .default, handler: { _ in self.restart() })
        alert.addAction(exit)
        self.present(alert, animated: true, completion: nil)
    }

    func didLose() {
        self.chat.messages.removeAll()
        
        state = GameState.youLose
        self.stateView.removeFromSuperview()
        self.stateView.label.text = state.rawValue
        self.view.addSubview(self.stateView)
        
        let alert = UIAlertController(title: "You lost! 😭", message: "", preferredStyle: .alert)
        let exit = UIAlertAction(title: "Play again", style: .default, handler: { _ in self.restart() })
        alert.addAction(exit)
        self.present(alert, animated: true, completion: nil)
    }
//
    func receivedMessage(name: String, msg: String, hour: String) {
//        self.chat.messages.append(Message(timestamp: hour, author: name, content: msg))
//        self.chatTableView.reloadData()
    }
    
    func youArePlayingAt(_ team: String) {
//        self.gameScene.player = Player(rawValue: team) ?? .disconnected
//        
//        self.playerNameLabel.text = "You are  "+gameScene.player.rawValue.capitalized
//        print("👾 You are player \(gameScene.player.rawValue)")
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
