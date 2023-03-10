//
//  BoardDelegate.swift
//  GenkitaiSo
//
//  Created by amanda.tavares on 13/02/23.
//

import Foundation

protocol BoardDelegate: AnyObject {
    func gameOver(winner: Player)
}
