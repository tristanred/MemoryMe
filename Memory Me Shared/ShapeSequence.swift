//
//  ShapeSequence.swift
//  Memory Me
//
//  Created by Tristan Dube on 2019-02-21.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import Foundation
import SpriteKit

/**
 The sequence class handles the list of shapes that needs to be clicked in a
 specific order to finish the game.
 
 This class handles many arrays. Some of them are concrete GameShape classes
 and others are the ordered list of shape kinds to click.
 
 Because this class directly creates GameShape instances in the constructor,
 the global function InitializeTextureMap must be called before creating a
 ShapeSequence.
 */
class ShapeSequence
{
    private var shapesInPlay: [GameShape] = [];
    private var shapeSequence: [ShapesKind] = []
    private var shapesClicked: [ShapesKind] = [];
    
    init()
    {
        logTrace(withMessage: "Creating empty Shape sequence.");
    }
    
    init(withStartingShapeCount count: Int)
    {
        logTrace(withMessage: "Creating shape sequence with \(count) shapes");
        
        for _ in 0..<count
        {
            let newShape = GameShape.random()!;
            
            shapesInPlay.append(newShape);
            shapeSequence.append(newShape.ShapeKind);
        }
    }
    
    init(withStartingShapes shapes: [GameShape])
    {
        logTrace(withMessage: "Creating shape sequence with \(shapes.count) shapes");
        
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
        let newShape = GameShape.random()!;
        
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
        return true;
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
