//
//  MemoryMeGame.swift
//  Memory Me
//
//  Created by Tristan Dube on 2019-02-22.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import Foundation
import SpriteKit

class MemoryMeGame
{
    private let Scene: SKScene;
    
    private let MemorySequence: ShapeSequence;
    
    init(scene: SKScene)
    {
        self.Scene = scene;
        
        InitializeTextureMap(withTextureSet: ShapeAssetsX128);
        
        self.MemorySequence = ShapeSequence(withStartingShapeCount: 1);
    }
}
