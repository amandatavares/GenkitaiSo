//
//  RPCWrapper.swift
//  GekitaiSo
//
//  Created by Amanda Tavares on 22/03/23.
//

import Foundation
import GRPC
import NIO

class RPCManager {
    
    static var shared = RPCManager()
    
    var client = GekitaiClient()
    var server = GekitaiServer()
    
    private init() {}
    
    public func run(handler: @escaping (Int) -> ()) {
        guard !server.isRunning else {
            handler(server.port!)
            return
        }
        server.onRun = handler
        DispatchQueue.global().async {
            self.server.run()
        }
    }
    
    public func onStart(handler: @escaping () -> ()) {
        server.provider.onStart = handler
    }
    
    public func onRestart(handler: @escaping () -> ()) {
        server.provider.onRestart = handler
    }
    
    public func onEnd(handler: @escaping (String) -> ()) {
        server.provider.onEnd = handler
    }
    
    public func onQuit(handler: @escaping () -> ()) {
        server.provider.onQuit = handler
    }
    
    public func onMove(handler: @escaping (Move) -> ()) {
        server.provider.onMove = handler
    }
    
    public func onMessage(handler: @escaping (Message) -> ()) {
        server.provider.onMessage = handler
    }
    
    
}
