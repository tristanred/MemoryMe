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
    
    var areaRectangle: CGSize;
    
    var currentShapes: [GameShape] = [];
    
    let velocityBounds: CGFloat = 5;
    
    init(area: CGSize, scene: SKScene)
    {
        Scene = scene;
        areaRectangle = area;
        
        createAreaBox();
    }
    
    func addShape(newShape: GameShape)
    {
        currentShapes.append(newShape);
        Scene.addChild(newShape);
        newShape.anchorPoint = self.Scene.anchorPoint;
        
        newShape.velocity.dx = CGFloat.random(in: -velocityBounds...velocityBounds);
        newShape.velocity.dy = CGFloat.random(in: -velocityBounds...velocityBounds);
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
    
    func processTouch(at point: CGPoint)
    {
        //var res = Scene.atPoint(point)
        let nodes = self.Scene.nodes(at: point)
        Scene.removeChildren(in: nodes);
    }
    
    func createAreaBox()
    {
        let boxShape = SKShapeNode(rect: Scene.frame);
        
        boxShape.lineWidth = 2;
        boxShape.strokeColor = .red;
        boxShape.glowWidth = 0.5;
        
        Scene.insertChild(boxShape, at: 0);
    }
}
