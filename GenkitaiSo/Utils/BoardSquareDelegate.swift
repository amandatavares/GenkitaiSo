//
//  BoardSquareDelegate.swift
//  GenkitaiSo
//
//  Created by amanda.tavares on 13/02/23.
//

import Foundation

// old TriangleStateDelegate
protocol BoardSquareDelegate: AnyObject {
    func didSelect(index: Index)
    func didUnselect(index: Index)
}
