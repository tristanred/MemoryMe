//
//  GameShape.swift
//  Memory Me iOS
//
//  Created by Tristan Dube on 2019-02-08.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import Foundation
import SpriteKit

class GameShape : SKSpriteNode
{
    public var ShapeKind: ShapesKind = .NONE;
    
    public var velocity: CGVector = CGVector(dx: 0, dy: 0);
    
    static func random() -> GameShape?
    {
        if(ShapeTextureMap.isEmpty)
        {
            print("Error: Creating a GameShape but the ShapeTextureMap is uninitialized.");
            
            return nil;
        }
        
        let randomShape = ShapeTextureMap.randomElement();
        
        let sprite: GameShape = GameShape(texture: randomShape?.value);
        sprite.ShapeKind = randomShape!.key;
        
        return sprite;
    }
}
