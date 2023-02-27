//
//  Constants.swift
//  GenkitaiSo
//
//  Created by amanda.tavares on 13/02/23.
//

import Foundation
import UIKit

enum Player: String {
    case disconnected = ""
    case playerTop = "playerTop"
    case playerBottom = "playerBottom"
}

enum GameResult {
    case topWin
    case bottomWin
}

enum GameState: String {
    case awaitingConnection = "Awaiting Connection from another Player"
    case waiting = "Waiting for the Opponent's Move"
    case yourTurn = "Make your Move!"
    case youWin = "You won!"
    case youLose = "You've lost!"
}

extension UIColor {
    struct PieceColor {
      static var top: UIColor  { return UIColor(named: "pieceTop") ?? .yellow }
      static var bottom: UIColor { return UIColor(named: "pieceBottom") ?? .blue }
    }
    struct Game {
        static var background: UIColor  { return UIColor(named: "background") ?? .systemBackground }
        static var gameBackground: UIColor { return UIColor(named: "gameBackground") ?? .systemGray6 }
        static var primary: UIColor  { return UIColor(named: "primary") ?? .systemBlue }
    }
}
