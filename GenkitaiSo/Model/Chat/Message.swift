//
//  Message.swift
//  GenkitaiSo
//
//  Created by amanda.tavares on 13/02/23.
//

import Foundation

struct Message: Codable {
    let timestamp: String
    let author: String
    let content: String
}
