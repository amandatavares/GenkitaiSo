//
//  Provider.swift
//  GekitaiSo
//
//  Created by Amanda Tavares on 22/03/23.
//

import Foundation
import GRPC
import NIO

class GekitaiProvider: GameProvider {
    
    var onInvite: (() -> ())?
    
    var onStart: (() -> ())?
    
    var onRestart: (() -> ())?
    
    var onEnd: ((String) -> ())?
    
    var onQuit: (() -> ())?
    
    var onMove: ((Move) -> ())?
    
    var onMessage: ((Message) -> ())?
    
    var interceptors: GameServerInterceptorFactoryProtocol?
    
    func invite(request: InviteRequest, context: GRPC.StatusOnlyCallContext) -> NIOCore.EventLoopFuture<InviteReply> {
        self.onInvite?()
        let response = InviteReply.with {
            $0.success = true
        }
        return context.eventLoop.makeSucceededFuture(response)
    }
    
    func start(request: StartRequest, context: GRPC.StatusOnlyCallContext) -> NIOCore.EventLoopFuture<StartReply> {
        self.onStart?()
        let response = StartReply.with {
            $0.success = true
        }
        return context.eventLoop.makeSucceededFuture(response)
    }
    
    func restart(request: RestartRequest, context: GRPC.StatusOnlyCallContext) -> NIOCore.EventLoopFuture<RestartReply> {
        self.onRestart?()
        let response = RestartReply.with {
            $0.success = true
        }
        return context.eventLoop.makeSucceededFuture(response)
    }
    
    func end(request: EndRequest, context: GRPC.StatusOnlyCallContext) -> NIOCore.EventLoopFuture<EndReply> {
        let winner = request.winner
        self.onEnd?(winner)
        
        let response = EndReply.with {
            $0.success = true
        }
        return context.eventLoop.makeSucceededFuture(response)
    }
    
    func quit(request: QuitRequest, context: GRPC.StatusOnlyCallContext) -> NIOCore.EventLoopFuture<QuitReply> {
        self.onQuit?()
        let response = QuitReply.with {
            $0.success = true
        }
        return context.eventLoop.makeSucceededFuture(response)
    }
    
    func move(request: MoveRequest, context: GRPC.StatusOnlyCallContext) -> NIOCore.EventLoopFuture<MoveReply> {
        if let move = try? JSONDecoder().decode(Move.self, from: request.jsonUTF8Data()) {
            self.onMove?(move)
        }
        let response = MoveReply.with {
            $0.success = true
        }
        return context.eventLoop.makeSucceededFuture(response)
    }
    
    func message(request: MessageRequest, context: GRPC.StatusOnlyCallContext) -> NIOCore.EventLoopFuture<MessageReply> {
        if let message = try? JSONDecoder().decode(Message.self, from: request.jsonUTF8Data()) {
            self.onMessage?(message)
        }
        let response = MessageReply.with {
            $0.success = true
        }
        return context.eventLoop.makeSucceededFuture(response)
    }
    
    
}
