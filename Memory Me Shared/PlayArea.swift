//
//  PlayArea.swift
//  Memory Me
//
//  Created by Tristan Dube on 2019-02-08.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import Foundation
import SpriteKit

class PlayArea
{
    private let Scene: SKScene;
    
    var areaRectangle: CGRect;
    
    var currentShapes: [GameShape] = [];
    
    init(area: CGRect, scene: SKScene)
    {
        Scene = scene;
        areaRectangle = area;
    }
    
    func addShape(newShape: GameShape)
    {
        currentShapes.append(newShape);
    }
    
    func updateShapes()
    {
        for shape in currentShapes
        {
            // Move all shapes
            shape.position.x += shape.velocity.dx;
            shape.position.y += shape.velocity.dy;
            
            // Clamp all shapes if out of bounds
            
            // Bounce of right edge
            if(shape.position.x + shape.size.width > areaRectangle.width)
            {
                shape.position.x = areaRectangle.width - shape.size.width;
                
                shape.velocity.dx *= -1;
            }
            
            // Bouce on bottom edge
            if(shape.position.y + shape.size.height > areaRectangle.height)
            {
                shape.position.y = areaRectangle.height - shape.size.height;
                
                shape.velocity.dy *= -1;
            }
            
            // Bounce of left edge
            if(shape.position.x < 0)
            {
                shape.position.x = 0;
                
                shape.velocity.dx *= -1;
            }
            
            // Bounce on top edge
            if(shape.position.y < 0)
            {
                shape.position.y = 0;
                
                shape.velocity.dy *= -1;
            }
        }
    }
}
