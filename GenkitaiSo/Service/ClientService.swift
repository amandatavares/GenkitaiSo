//
//  ClientService.swift
//  GekitaiSo
//
//  Created by Amanda Tavares on 22/03/23.
//

//Entender
import Foundation
import GRPC
import NIO

class GameClient {
    
    var client: GameServiceClient!
    var delegate: GameDelegate!
    
    func run(addressAndPort: String, delegate: GameDelegate, handler: @escaping (String,Int) -> Void) {
             
        self.delegate = delegate
        
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
//        defer {
//          try? group.syncShutdownGracefully()
//        }

        let ip = "\(addressAndPort.split(separator: ":")[0])"
        let port = Int(addressAndPort.split(separator: ":")[1])!
        
        let channel = ClientConnection.insecure(group: group)
          .connect(host: ip, port: port)
        
        self.client = GameServiceClient(channel: channel)
        
        print("🤖 client started with address \(ip):\(port)")
        
        handler(RPCWrapper.shared.server.ip, RPCWrapper.shared.server.serverPort)
        
        RunLoop.main.run(until: .distantFuture)
        
    }
    
}
