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
import Logging

class GekitaiClient {
    
    var port: Int!
    
    private var group: MultiThreadedEventLoopGroup!
    
    lazy var service: GameNIOClient = {
        let target = ConnectionTarget.hostAndPort("localhost", port)
        let configuration = ClientConnection.Configuration(target: target, eventLoopGroup: group)
        let connection = ClientConnection(configuration: configuration)
        return GameNIOClient(channel: connection)
        
    }()
    
    init() {
        group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    }
    
    deinit {
        do {
            try group.syncShutdownGracefully()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func start(onResponse: (Bool) -> ()) {
        let request = StartRequest.with { _ in }
        do {
            let response = try service.start(request).response.wait()
            onResponse(response.success)
        } catch {
            print("Failed: \(error)")
        }
    }
    
    func invite(name: String, onResponse: (Bool) -> ()) {
        
        let request = InviteRequest.with {
            $0.name = name
        }
        
        do {
            let response = try service.invite(request).response.wait()
            onResponse(response.success)
        } catch {
            print("Failed: \(error)")
        }
    }
    
    func restart(onResponse: (Bool) -> ()) {
        
        let request = RestartRequest.with { _ in }

        do {
            let response = try service.restart(request).response.wait()
            onResponse(response.success)
        } catch {
            print("Failed: \(error)")
        }
        
    }
    
    func end(onResponse: (Bool) -> ()) {
        
        let request = EndRequest.with {
            $0.winner = UserDefaults.standard.string(forKey: "name")!
        }

        do {
            let response = try service.end(request).response.wait()
            onResponse(response.success)
        } catch {
            print("Failed: \(error)")
        }
        
    }
    
    func quit(onResponse: (Bool) -> ()) {
        
        let request = QuitRequest.with { _ in }

        do {
            let response = try service.quit(request).response.wait()
            onResponse(response.success)
        } catch {
            print("Failed: \(error)")
        }
        
    }
    
    func send(_ move: Move, onResponse: (Bool) -> ()) {
        do {
            let data = try JSONEncoder().encode(move)
            let request = try MoveRequest(jsonUTF8Data: data)
            let response = try service.move(request).response.wait()
            onResponse(response.success)
        } catch {
            print("Failed: \(error)")
        }
    }
    
    func send(_ message: Mensagem, onResponse: (Bool) -> ()) {
        do {
            let data = try JSONEncoder().encode(message)
            let request = try MessageRequest(jsonUTF8Data: data)
            let response = try service.message(request).response.wait()
            onResponse(response.success)
        } catch {
            print("Failed: \(error)")
        }
    }
    
}
