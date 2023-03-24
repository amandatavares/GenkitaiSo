//
//  Provider.swift
//  GekitaiSo
//
//  Created by Amanda Tavares on 22/03/23.
//

import Foundation
import GRPC
import NIO

class Provider: GameServiceProvider {
    
    weak var delegate: GameDelegate!
    
    init(delegate: GameDelegate!) {
        self.delegate = delegate
    }
    
    let didReceiveMessage: (String, String, GameDelegate) -> () = { author, content, delegate in
        delegate.receivedMessage(name: author, msg: content, hour: "") //chance to datetime
    }
    
    
//    var onInvite: (() -> ())?
//
//    var onStart: (() -> ())?
//
//    var onRestart: (() -> ())?
//
//    var onEnd: ((String) -> ())?
//
//    var onQuit: (() -> ())?
//
//    var onMove: ((Move) -> ())?
//
//    var onMessage: ((Mensagem) -> ())?
//
    
    
//    rpc Connect(ConnectionRequest) returns (ConnectionResponse) {} //invite
//    rpc Start(StartRequest) returns (StartResponse) {} //start
//    rpc GameOver(WinnerRequest) returns (GameResult) {} //end
//    rpc Move(MoveRequest) returns (NextTurn) {}
//    rpc SendMessage(ChatMessage) returns (ChatMessage) {}

    var interceptors: GameServiceServerInterceptorFactoryProtocol?
    
    func connectTo(request: ConnectionRequest, context: GRPC.StatusOnlyCallContext) -> NIOCore.EventLoopFuture<ConnectionResponse> {
        
        print("connect requested from \(request.ip) on \(request.port)")
        
        let response = ConnectionResponse.with {
            $0.success = true
//            $0.description_p = "\(GRPCWrapper.shared.server.ip):\(GRPCWrapper.shared.server.serverPort)”
        }
        
//        RPCWrapper.shared.runClient(addressAndPort: "\(request.ip):\(request.port)", delegate: self.delegate, handler: { ip, port in
//            DispatchQueue.main.async {
//                self.delegate.youArePlayingAt("bottom")
//                self.delegate.didStart()
//            }
//        })
            
        return context.eventLoop.makeSucceededFuture(response)
    }
    
    func start(request: StartRequest, context: GRPC.StatusOnlyCallContext) -> NIOCore.EventLoopFuture<StartResponse> {
        
        let response = StartReply.with {
            $0.success = true
        }
        return context.eventLoop.makeSucceededFuture(response)
    }
    

    func end(request: WinnerRequest, context: GRPC.StatusOnlyCallContext) -> NIOCore.EventLoopFuture<GameResult> {
        let winner = request.name
        let loser = request.name.lowercased() == "top" ? "bottom" : "top"
                
        if winner.lowercased() == RPCWrapper.player.rawValue.lowercased() {
            self.delegate.didWin()
        } else {
            self.delegate.didLose()
        }
        
        let gameFinalResult = GameResult.with {
            $0.winner = winner
            $0.loser = loser
        }
        
        return context.eventLoop.makeSucceededFuture(gameFinalResult)
    }
    
    func move(request: MoveRequest, context: StatusOnlyCallContext) -> EventLoopFuture<NextTurn> {
        
        print("move Request has been received: from (\(request.from.row),\(request.from.column)) to (\(request.to.row),\(request.to.column))")
        
        let originIndex = Index(
            row: Int(request.from.row),
            column: Int(request.from.column)
        )
        
        let newIndex = Index(
            row: Int(request.to.row),
            column: Int(request.to.column)
        )
        
        let nextTurnName = request.name.lowercased() == "top" ? "bottom" : "top"
        
        self.delegate.playerDidMove(request.name, from: originIndex, to: newIndex)
        self.delegate.newTurn(nextTurnName)
        
        let nextTurnMessage = NextTurn.with {
            $0.name = nextTurnName
        }
        
        return context.eventLoop.makeSucceededFuture(nextTurnMessage)
        
    }
    
    func message(request: ChatMessage, context: GRPC.StatusOnlyCallContext) -> NIOCore.EventLoopFuture<ChatMessage> {
        
        print("new message: \(request.name)")
        
        didReceiveMessage(request.name, request.content, delegate)
        
        let response = ChatMessage.with {
            $0.name = request.author
            $0.content = request.content
        }
        return context.eventLoop.makeSucceededFuture(response)
    }
    
    
}
