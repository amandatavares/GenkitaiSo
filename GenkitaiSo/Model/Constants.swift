//
//  Constants.swift
//  GenkitaiSo
//
//  Created by amanda.tavares on 13/02/23.
//

import Foundation

enum Player: String {
    case disconnected = ""
    case leftPlayer = "left"
    case rightPlayer = "right"
}

enum GameResult {
    case leftWin
    case rightWin
}

enum GameState: String {
    case awaitingConnection = "Awaiting Connection from another Player"
    case waiting = "Waiting for the Opponent's Move"
    case yourTurn = "Make your Move!"
    case youWin = "You won!"
    case youLose = "You've lost!"
}


