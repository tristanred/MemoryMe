//
//  ShapeSequence.swift
//  Memory Me
//
//  Created by Tristan Dube on 2019-02-21.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import Foundation
import SpriteKit

class ShapeSequence
{
    private let shapesInPlay: [GameShape];
    
    init()
    {
        shapesInPlay = [];
    }
    
    init(withStartingShapeCount count: Int)
    {
        shapesInPlay = [];
        
        for _ in 0...count
        {
            
        }
    }
    
    init(withStartingShapes shapes: [GameShape])
    {
        shapesInPlay = shapes;
    }
}
