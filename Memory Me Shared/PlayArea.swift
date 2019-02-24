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
    private var debugRect: SKShapeNode?;
    
    var areaRectangle: CGRect;
    
    var currentShapes: [GameShape] = [];
    
    let velocityBounds: CGFloat = 2;
    
    init(area: CGRect, scene: SKScene)
    {
        Scene = scene;
        areaRectangle = area;
        
        createDebugBoxArea();
    }
    
    func resetSize(_ newSize: CGRect)
    {
        areaRectangle = newSize;
        self.debugRect?.removeFromParent();
        createDebugBoxArea();
    }
    
    func addShape(newShape: GameShape)
    {
        currentShapes.append(newShape);
        Scene.addChild(newShape);
        newShape.anchorPoint = self.Scene.anchorPoint;
        
        newShape.velocity.dx = CGFloat.random(in: -velocityBounds...velocityBounds);
        newShape.velocity.dy = CGFloat.random(in: -velocityBounds...velocityBounds);
    }
    
    func addShape(fromListOfShapes list: [GameShape])
    {
        for i in list
        {
            self.addShape(newShape: i);
        }
    }
    
    func clear()
    {
        let nodes = self.Scene.children;
        
        for nodeCheck in nodes
        {
            if(nodeCheck is GameShape)
            {
                Scene.removeChildren(in: [nodeCheck]);
                currentShapes.removeAll();
            }
        }
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
    
    func processTouch(at point: CGPoint) -> ShapesKind
    {
        let nodes = self.Scene.nodes(at: point);
        
        for nodeCheck in nodes
        {
            if(nodeCheck is GameShape)
            {
                Scene.removeChildren(in: [nodeCheck]);
                
                return (nodeCheck as! GameShape).ShapeKind;
            }
        }
        
        return ShapesKind.NONE;
    }
    
    func createDebugBoxArea()
    {
        self.debugRect = SKShapeNode(rect: areaRectangle);
        
        self.debugRect!.lineWidth = 2;
        self.debugRect!.strokeColor = .red;
        self.debugRect!.glowWidth = 0.5;
        
        Scene.insertChild(self.debugRect!, at: 0);
    }
}
