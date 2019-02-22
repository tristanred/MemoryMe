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
    private var shapesInPlay: [GameShape] = [];
    private var shapeSequence: [ShapesKind] = []
    private var shapesClicked: [ShapesKind] = [];
    
    init()
    {
    }
    
    init(withStartingShapeCount count: Int)
    {
        for _ in 0..<count
        {
            let newShape = GameShape.random();
            
            shapesInPlay.append(newShape);
            shapeSequence.append(newShape.ShapeKind);
            
        }
    }
    
    init(withStartingShapes shapes: [GameShape])
    {
        shapesInPlay = shapes;
        
        shapeSequence = shapes.map( {(shape: GameShape) -> ShapesKind in
            return shape.ShapeKind;
        });
    }
    
    func IsFinished() -> Bool
    {
        return shapesClicked.count == shapesInPlay.count;
    }
    
    func EvolveSequence()
    {
        let newShape = GameShape.random();
        
        shapesInPlay.append(newShape);
        shapeSequence.append(newShape.ShapeKind);
    }
    
    func RestartSequence()
    {
        self.shapesClicked.removeAll();
    }
    
    func GetSequenceShapes() -> [GameShape]
    {
        return shapesInPlay;
    }
    
    func ShapeClicked(kind: ShapesKind)
    {
        self.shapesClicked.append(kind);
    }
    
    func SequenceIsCorrect() -> Bool
    {
        for i in 0..<shapesClicked.count
        {
            if(shapesClicked[i] != shapeSequence[i])
            {
                return false;
            }
        }
        
        return true;
    }
}
