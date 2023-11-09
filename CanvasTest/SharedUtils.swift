//
//  SharedUtils.swift
//  CanvasTest
//
//  Created by andy on 2023/11/9.
//

import Foundation

public func distance(between p1: CGPoint, and p2: CGPoint) -> CGFloat {
    // 計算 x 方向的距離
    let dx = p2.x - p1.x
    // 計算 y 方向的距離
    let dy = p2.y - p1.y

    // 使用勾股定理計算距離
    return sqrt(dx * dx + dy * dy)
}

