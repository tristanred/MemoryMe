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
    
    private let highscoreText: HighscoreText;
    private var highscoreTimer: Timer?;
    
    private var shapeScale: Double = 1;
    
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
        
        self.highscoreText = HighscoreText();
        self.highscoreText.position = CGPoint(x: scene.frame.maxX / 2, y: scene.frame.maxY * 0.025);
        print("HS Text : \(self.highscoreText.position)");
        self.highscoreText.setText(10);
        scene.addChild(self.highscoreText);
        
        let currentDate = StatisticsManager.default.current.dailySequenceMaximum.date;
        let isSavedDateToday = Calendar.current.isDateInToday(currentDate);
        
        if(isSavedDateToday == false)
        {
            logTrace(withMessage: "Resetting the daily total");
            
            StatisticsManager.default.current.dailySequenceMaximum.amount = 0;
            StatisticsManager.default.current.dailySequenceMaximum.date = Date();
            
            StatisticsManager.default.save();
        }
        
        print("Created game instance");
        logTrace(withMessage: "Created game instance", andProperties: [
            "Cell Width" : "\(cellWidth)",
            "Cell Height" : "\(cellHeigth)"
        ], export: true);
    }
    
    func LoadTextures()
    {
        if(self.assetsAreLoaded == true)
        {
            logWarning(withMessage: "LoadTexture called when assets are already loaded.")
            
            return;
        }
        
        InitializeTextureMap(withTextureSet: ShapeAssetsX256);
        
        assetsAreLoaded = true;
    }

    func StartNewGame()
    {
        if(assetsAreLoaded == false)
        {
            logError(withMessage: "StartNewGame called before assets are loaded.", export: true)
            
            return;
        }
        
        self.showHighscore();
        highscoreTimer = Timer.scheduledTimer(withTimeInterval: 20, repeats: true, block: { (Timer) in
            self.showHighscore();
        });

        logTrace(withMessage: "New game started");
        
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
                logError(withMessage: "Unable to add shape because of reasons.", export: true)
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
    
    func activateDebugLayer(state value: Bool)
    {
        if(value)
        {
            self.RecreateDebugRects();
        }
        else
        {
            for node in Scene.children
            {
                if node is SKShapeNode
                {
                    node.removeFromParent();
                }
            }
        }
    }
    
    func RecreateDebugRects()
    {
        if(useDebugLayer() == false)
        {
            return;
        }
        
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
            logTrace(withMessage: "Player Success", andProperties: ["Sequence Length" : "`\(self.MemorySequence!.GetSequenceShapes().count)`"], export: true)
            
            StatisticsManager.default.current.gamesWon += 1;
            
            if(MemorySequence!.GetCurrentLevelLength() > StatisticsManager.default.current.dailySequenceMaximum.amount)
            {
                StatisticsManager.default.current.dailySequenceMaximum.amount = Int32(MemorySequence!.GetCurrentLevelLength());
            }

            StatisticsManager.default.save();

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
                
                // Using a 30% grow seems to work.
//                self.Scene.size.width *= 1.3;
//                self.Scene.size.height *= 1.3;
                self.shapeScale *= 0.75;
                self.ResizeGame(withFrame: CGRect(x: 0, y: 0, width: self.Scene.size.width, height: self.Scene.size.height));
                
                logTrace(withMessage: "Grid growing", andProperties: ["New Size" : "(w: `\(self.Scene.size.width)`, h: `\(self.Scene.size.height)`"], export: true)
            }
            
            for shape in self.MemorySequence!.GetSequenceShapes()
            {
                if let res = self.Organizer.addShape(shape: shape)
                {
                    res.shapeOnSlot!.setScale(CGFloat(shapeScale));
                    Scene.addChild(res.shapeOnSlot!);
                }
                else
                {
                    logError(withMessage: "Unable to add shape because of reasons.")
                }
            }
            
            self.Organizer.shuffleShapes();
            self.Organizer.resetShapePositions();
        }
        else if(MemorySequence!.SequenceIsCorrect() == false)
        {
            logTrace(withMessage: "Player Failed", andProperties: ["Sequence Length" : "`\(self.MemorySequence!.GetSequenceShapes().count)`"], export: true);
            
            StatisticsManager.default.current.gamesLost += 1;
            StatisticsManager.default.save();
            
            let clearedShapes = self.Organizer.clear();
            for shape in clearedShapes
            {
                shape.resetShape();
                shape.removeFromParent();
            }
            
            self.MemorySequence!.ResetSequence();
            
            for shape in self.MemorySequence!.GetSequenceShapes()
            {
                if let res = self.Organizer.addShape(shape: shape)
                {
                    res.shapeOnSlot!.setScale(CGFloat(shapeScale));
                    Scene.addChild(res.shapeOnSlot!);
                }
                else
                {
                    logError(withMessage: "Failed to add shape due to mysterious reasons.");
                }
            }
            
            self.Organizer.shuffleShapes();
            self.Organizer.resetShapePositions();
        }
    }
    
    func Update()
    {
    }
    
    func showHighscore()
    {
        let amount = StatisticsManager.default.current.dailySequenceMaximum.amount;
        self.highscoreText.setText(Int(amount));
        self.highscoreText.temporaryShow();
    }
    
    func ProcessClick(at point: CGPoint)
    {
        if (preventInteraction == true)
        {
            StatisticsManager.default.current.overclick += 1;
            
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
