//
//  RPCWrapper.swift
//  GekitaiSo
//
//  Created by Amanda Tavares on 22/03/23.
//

import Foundation
import GRPC
import NIO

class RPCWrapper {
    
    static var shared = RPCWrapper()
    
    static var player: Player = .disconnected
    
    var client = GameClient() //GekitaiClient
    var server = GameServer() //GekitaiServer
    
    private init() {}
    
    func runServer(delegate: GameDelegate, handler: @escaping (Int) -> ()) {
        DispatchQueue.global().async {
            self.server.run(delegate: delegate, handler: { })
        }
    }
    func runClient(addressAndPort: String, delegate: GameDelegate, handler: @escaping (String, Int) -> Void) {
        DispatchQueue.global().async {
            self.client.run(addressAndPort: addressAndPort, delegate: delegate, handler: handler)
        }
    }

    func connectTo(ip: String, port: Int, handler: (Bool?,String?) -> Void) {
       let connectionRequest = ConnectionRequest.with {
           $0.ip = RPCWrapper.shared.server.ip
           $0.port = Int32(RPCWrapper.shared.server.serverPort)
       }
       
       let connectionRequestResult = RPCWrapper.shared.client.client.connectTo(connectionRequest)
       
       do {
           let result = try connectionRequestResult.response.wait()
           print("connectTo response description: \(result.description_p) and success: \(result.success)")
           handler(result.success, result.description_p)
       } catch {
           print("Failed waiting for connectTo response: \(error)")
           handler(nil,nil)
       }
    }
    
    func sendMessage(name: String, content: String, handler: (String?, String?) -> Void) {
            let messageToSend = ChatMessage.with {
                $0.name = name
                $0.content = content
            }
            
            let sendMessageRequest = self.client.client.sendMessage(messageToSend)
            
            do {
                let result = try sendMessageRequest.response.wait()
                print("sendMessage response has been received - \(result.author): \(result.content)")
                handler(result.author, result.content)
            } catch {
                print("Failed waiting for sendMessage response: \(error)")
                handler(nil,nil)
            }
        }
        
        func receiveMessage(name: String, content: String, handler: @escaping (String, String) -> Void) {
            handler(name, content)
        }
        
        func endTurnAndMove(name: String, from originIndex: Index, to newIndex: Index, handler: (String?) -> Void) {
            
            let moveRequest = MoveRequest.with { move in
                let origin = MoveRequest.FROM.with { index in
                    index.row = Double(originIndex.row)
                    index.column = Double(originIndex.column)
                }
                
                let new = MoveRequest.TO.with { index in
                    index.row = Double(newIndex.row)
                    index.column = Double(newIndex.column)
                }
                
                move.from = origin
                move.to = new
                move.name = name
            }
            
            let request = self.client.client.move(moveRequest)
            
            do {
                let result = try request.response.wait()
                print("endTurnAndMove response has been received - new turn \(result.name)")
                handler(result.name)
            } catch {
                print("Failed waiting for endTurnAndMove response: \(error)")
                handler(nil)
            }
            
        }
        
        func gameOver(winner: String, handler: (String?) -> Void) {
            
            let winnerRequest = WinnerRequest.with {
                $0.name = winner
            }
            
            let request = self.client.client.gameOver(winnerRequest)
            
            do {
                let result = try request.response.wait()
                print("gameOver response has been received - result winner: \(result.winner) loser: \(result.loser)")
                handler(result.winner)
            } catch {
                print("Failed waiting for endTurnAndMove response: \(error)")
                handler(nil)
            }
        }
    
    
}
