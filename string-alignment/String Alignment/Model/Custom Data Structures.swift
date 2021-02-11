//
//  Custom Data Structures.swift
//  Algo Snake
//
//  Created by Álvaro Santillan on 7/1/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import SpriteKit

struct Tuple: Hashable {
    var x: Int
    var y: Int
}

struct ColorAndLocation: Hashable {
    var color: UIColor
    var location: Tuple
}

struct SkNodeAndLocation: Hashable {
    var square: SKShapeNode
    var location: Tuple
}

struct SkNodeLocationAndColor: Hashable {
    var square: SKShapeNode
    var location: Tuple
    var color: UIColor
}

struct ColorComponents {
    var red = CGFloat(0)
    var green = CGFloat(0)
    var blue = CGFloat(0)
    var alpha = CGFloat(0)
}
