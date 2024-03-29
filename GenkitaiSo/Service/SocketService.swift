
  SocketService.swift
  GenkitaiSo

  Created by amanda.tavares on 14/02/23.




class SocketService {

    let manager: SocketManager
    let socket: SocketIOClient
    var player: String! //player

    weak var delegate: GameDelegate! {
        didSet {
            self.start()
        }
    }

    init() {
        manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
        socket = manager.defaultSocket
        configSocket()
    }

    private func start() {
        socket.connect()
    }

    func restart() {
        socket.disconnect()
        socket.connect()
    }

    func giveUp(player: String) {
        self.socket.emit("giveUp", player)
//        exitPlayer(player: player)
    }

    func conectPlayer() {
        self.socket.emit("ctUser")
    }

    func newTurn() {
        self.socket.emit("newTurn", player)
    }

    func exitPlayer(player: String) {
        self.socket.emit("userExitUpdate", player)
    }

    func move(from origin: Position, to new: Position) {
        self.socket.emit("playerMove", player, origin.x, origin.y, new.x, new.y)
    }

    func gameOver(winner: Player) {
        self.socket.emit("gameOver", winner.rawValue)
    }

    func sendMessage(author: String, content: String) {
        self.socket.emit("chatMessage", author, content)
    }

    func configSocket() {

        socket.on("player") { [weak self] data, ack in
            if let name = data[0] as? String {
                if self?.player == nil {
                    self?.player = name
                    self?.delegate?.youArePlayingAt(name)
                }
                self?.delegate.receivedMessage(name: "🟢 \(name)", msg: "Joined the room", hour: "")
            }
        }

        socket.on(clientEvent: .disconnect) { [weak self] data, ack in
            self?.player = ""
            self?.delegate.youArePlayingAt("")
        }

        socket.on("uList") { [weak self] data, ack -> Void in
            if let name = data[0] as? String {
                self?.delegate.receivedMessage(name: "🟢 \(name)", msg: "Joined the room", hour: "")
            }
        }

        socket.on("startGame") { [weak self] data, ack in
            self?.delegate.didStart()
            return
        }

        socket.on("newChatMessage") { [weak self] data, ack in
            if let name = data[0] as? String, let msg = data[1] as? String, let hour = data[2] as? String  {
                self?.delegate.receivedMessage(name: name, msg: msg, hour: hour)
            }
        }

        socket.on("playerMove") { [weak self] data, ack in
            if let name = data[0] as? String, let originX = data[1] as? Double, let originY = data[2] as? Double, let newX = data[3] as? Double, let newY = data[4] as? Double {
//                self?.delegate.playerDidMove(name, from: Index(row: originX, column: originY), to: Index(row: newX, column: newY))
                self?.delegate.playerDidMove(name, from: Position(x: originX, y: originY), to: Position(x: newX, y: newY))

            }
        }

        socket.on("win") { [weak self] data, ack in
            self?.delegate.didWin()
        }

        socket.on("lose") { [weak self] data, ack in
            self?.delegate.didLose()
        }

        socket.on("currentTurn") { [weak self] data, ack in
            if let name = data[0] as? String {
                self?.delegate.newTurn(name)
            }
        }

        socket.onAny {
            print("Got event: \($0.event), with items: \($0.items!)")
        }
    }
}
