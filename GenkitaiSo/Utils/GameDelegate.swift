//
//  GameDelegate.swift
//  GekitaiSo
//
//  Created by Amanda Tavares on 22/03/23.
//

import Foundation

protocol GameDelegate: AnyObject {
    func didStart()

    func newTurn(_ name: String)
    func playerDidMove(_ name: String, from originIndex: Position, to newIndex: Position)

    func didWin()
    func didLose()

    func receivedMessage(name: String, msg: String, hour: String)

    func youArePlayingAt(_ team: String) //yourPlayer
}
