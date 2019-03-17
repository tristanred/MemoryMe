//
//  MemoryMeGame.swift
//  Memory Me
//
//  Created by Tristan Dube on 2019-02-22.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import Foundation
import SpriteKit

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

/**
 MemoryMe Game Core class.
 
 This class handles all the parts of the game. Handling the shapes sprites on
 the screen, checking the sequence, handling the textures loading.
 */
class MemoryMeGame
{
    private let Scene: GameScene;
    
    private var assetsAreLoaded: Bool;
    
    private var MemorySequence: ShapeSequence?;
    private var Organizer: GridOrganizer;
    
    private var initialSize: CGRect;
    
    private var cellWidth: CGFloat;
    private var cellHeigth: CGFloat;
    
    /**
     * Flag used to prevent clicking multiple shape touches, this helps
     * concurrency callbacks when shapes finish their animation.
     */
    private var preventInteraction: Bool = false;
    
    init(_ scene: GameScene, _ startingSize: CGRect)
    {
        self.Scene = scene;
                
        self.Organizer = GridOrganizer(areaSize: startingSize);
        initialSize = startingSize;
        cellWidth = initialSize.width / CGFloat(self.Organizer.gridColumns);
        cellHeigth = initialSize.height / CGFloat(self.Organizer.gridRows);
        
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
        
        InitializeTextureMap(withTextureSet: ShapeAssetsX256);
        
        assetsAreLoaded = true;
    }

    func StartNewGame()
    {
        if(assetsAreLoaded == false)
        {
            print("Error: StartNewGame called before assets are loaded.");
            
            return;
        }
        
        MSAnalytics.trackEvent("Game Started");
        
        self.RecreateDebugRects();
        
        self.MemorySequence = ShapeSequence(withStartingShapeCount: 1);
        
        let initialSequence = self.MemorySequence?.GetSequenceShapes();
        for shape in initialSequence!
        {
            if self.Organizer.addShape(shape: shape) != nil
            {
                self.Scene.addChild(shape);
            }
            else
            {
                print("Unable to add shape because of reasons.");
            }
        }
        self.Organizer.shuffleShapes();
        self.Organizer.resetShapePositions();
    }
    
    func debugKeyPressed()
    {
        for shape in (self.MemorySequence?.GetSequenceShapes())!
        {
            self.MemorySequence?.ShapeClicked(kind: shape.ShapeKind);
        }
        
        self.VerifyGameStatus();
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
            
            #if os(OSX)
            debugSquare.strokeColor = NSColor.red;
            #elseif os(iOS)
            debugSquare.strokeColor = UIColor.red;
            #endif

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
            MSAnalytics.trackEvent("Player Success", withProperties: ["Sequence Length" : "`\(self.MemorySequence!.GetSequenceShapes().count)`"]);
            
            // Sequence is finished. Add a shape to the sequence, shuffle the
            // positions and add the shapes back to the Scene.
            
            let clearedShapes = self.Organizer.clear();
            for shape in clearedShapes
            {
                shape.resetShape();
                shape.removeFromParent();
            }
            
            self.MemorySequence!.EvolveSequence();
            self.MemorySequence!.RestartSequence();
            
            if(self.Organizer.gridMustGrow(amount: self.MemorySequence!.GetSequenceShapes().count))
            {
                self.Organizer.growGrid();
                //let increase = min(self.cellWidth, self.cellHeigth);
                self.Scene.size.width *= 1.3;
                self.Scene.size.height *= 1.3;
                self.ResizeGame(withFrame: CGRect(x: 0, y: 0, width: self.Scene.size.width, height: self.Scene.size.height));
                
                MSAnalytics.trackEvent("Grid growing", withProperties: ["New Size" : "(w: `\(self.Scene.size.width)`, h: `\(self.Scene.size.height)`"])
            }
            
            for shape in self.MemorySequence!.GetSequenceShapes()
            {
                if let res = self.Organizer.addShape(shape: shape)
                {
                    Scene.addChild(res.shapeOnSlot!);
                }
                else
                {
                    print("Unable to add shape because of reasons.");
                }
            }
            
            self.Organizer.shuffleShapes();
            self.Organizer.resetShapePositions();
        }
        else if(MemorySequence!.SequenceIsCorrect() == false)
        {
            MSAnalytics.trackEvent("Player Failed", withProperties: ["Sequence Length" : "`\(self.MemorySequence!.GetSequenceShapes().count)`"]);
            
            let clearedShapes = self.Organizer.clear();
            for shape in clearedShapes
            {
                shape.resetShape();
                shape.removeFromParent();
            }
            
            self.MemorySequence!.RestartSequence();
            
            for shape in self.MemorySequence!.GetSequenceShapes()
            {
                if let res = self.Organizer.addShape(shape: shape)
                {
                    Scene.addChild(res.shapeOnSlot!);
                }
                else
                {
                    MSAnalytics.trackEvent("Failed to add shape due to mysterious reasons.");
                    
                    print("Unable to add shape because of reasons.");
                }
            }
            
            self.Organizer.shuffleShapes();
            self.Organizer.resetShapePositions();
        }
    }
    
    func Update()
    {
    }
    
    func ProcessClick(at point: CGPoint)
    {
        if (preventInteraction == true)
        {
            return;
        }
        
        let result = self.Organizer.gridPositions.first { (slot) -> Bool in
            return slot.shapeOnSlot?.contains(point) ?? false;
        };
        
        if let touchedSlot = result
        {
            if let slot = touchedSlot.shapeOnSlot
            {
                preventInteraction = true;
                
                slot.doClickAnimation(){
                    touchedSlot.shapeOnSlot?.removeFromParent();
                    self.MemorySequence?.ShapeClicked(kind: touchedSlot.shapeOnSlot!.ShapeKind);
                    self.VerifyGameStatus();
                    
                    self.preventInteraction = false;
                }
            }
        }
    }
    
    func ResizeGame(withFrame frame: CGRect)
    {
        self.Organizer.onResize(withFrame: frame);
        self.RecreateDebugRects();
    }
}
