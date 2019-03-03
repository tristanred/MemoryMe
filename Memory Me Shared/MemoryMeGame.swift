//
//  MemoryMeGame.swift
//  Memory Me
//
//  Created by Tristan Dube on 2019-02-22.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import Foundation
import SpriteKit

/**
 MemoryMe Game Core class.
 
 This class handles all the parts of the game. Handling the shapes sprites on
 the screen, checking the sequence, handling the textures loading.
 */
class MemoryMeGame
{
    private let Scene: SKScene;
    
    private var assetsAreLoaded: Bool;
    
    private var MemorySequence: ShapeSequence?;
    private var Area: PlayArea?;
    private var Organizer: GridOrganizer;
    
    init(_ scene: SKScene, _ startingSize: CGRect)
    {
        self.Scene = scene;
        
        self.Area = PlayArea(area: startingSize, scene: self.Scene);
        
        self.Organizer = GridOrganizer(areaSize: startingSize);
        
        assetsAreLoaded = false;
    }
    
    func LoadTextures()
    {
        if(self.assetsAreLoaded == true)
        {
            // Should call ReloadTexture to change the texture set.
            print("Warning: LoadTexture called when assets are already loaded.");
            
            return;
        }
        
        InitializeTextureMap(withTextureSet: ShapeAssetsX128);
        
        assetsAreLoaded = true;
    }

    func StartNewGame()
    {
        if(assetsAreLoaded == false)
        {
            print("Error: StartNewGame called before assets are loaded.");
            
            return;
        }
        
        self.RecreateDebugRects();
        
        self.MemorySequence = ShapeSequence(withStartingShapeCount: 1);
        
        let initialSequence = self.MemorySequence?.GetSequenceShapes();
        for shape in initialSequence!
        {
            let result = self.Organizer.placeShapeAtRandomPosition(shape: shape);
            self.Scene.addChild(shape);
        }
    }
    
    func RecreateDebugRects()
    {
        for node in Scene.children
        {
            if node is SKShapeNode
            {
                node.removeFromParent();
            }
        }

        for slot in self.Organizer.gridPositions
        {
            let debugSquare = SKShapeNode(rect: slot.area);
            //debugSquare.fillColor = NSColor.red;
            debugSquare.strokeColor = NSColor.red;

            Scene.addChild(debugSquare);
        }
    }
    
    /**
     Function called after every player move. This checks if the player has
     clicked on the correct shape and takes action depending on the result.
     
     If the correct shape is clicked the game keeps going.
     If the wrong shape is clicked, we reset the game.
     If the last shape was clicked, we finish the game and increase the sequence
     size.
    */
    public func VerifyGameStatus()
    {
        if(self.MemorySequence!.IsFinished())
        {
            self.Organizer.clear();
            self.MemorySequence!.EvolveSequence();
            self.MemorySequence!.RestartSequence();
            
            for shape in self.MemorySequence!.GetSequenceShapes()
            {
                self.Organizer.placeShapeAtRandomPosition(shape: shape);
                self.Scene.addChild(shape);
            }
        }
        else if(MemorySequence!.SequenceIsCorrect() == false)
        {
            // Restart
            self.Organizer.clear();
            self.MemorySequence!.RestartSequence();
            
            // TODO : Reset and add shapes back
            for shape in self.MemorySequence!.GetSequenceShapes()
            {
                self.Organizer.placeShapeAtRandomPosition(shape: shape);
                self.Scene.addChild(shape);
            }
        }
    }
    
    func Update()
    {
    }
    
    func ProcessClick(at point: CGPoint)
    {
        let result = self.Organizer.gridPositions.first { (slot) -> Bool in
            return slot.shapeOnSlot?.contains(point) ?? false;
        };
        
        if let touchedSlot = result
        {
            touchedSlot.shapeOnSlot?.removeFromParent();
            self.MemorySequence?.ShapeClicked(kind: touchedSlot.shapeOnSlot!.ShapeKind);
            self.VerifyGameStatus();
        }
    }
    
    func ResizeGame(withFrame frame: CGRect)
    {
        self.Organizer.resizeGrid(withFrame: frame);
        self.RecreateDebugRects();
    }
}
