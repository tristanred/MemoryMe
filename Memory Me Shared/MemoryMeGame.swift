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
    enum GameState
    {
        case INIT;
        case LOADED;
        case READY; // After texture are loaded, before game is started. Might not need that state
        case STARTED;
        case ENDED;
    }
    
    private var GameState: GameState;
    
    private let Scene: SKScene;
    
    private var assetsAreLoaded: Bool;
    
    private var MemorySequence: ShapeSequence?;
    private var Area: PlayArea?;
    
    init(_ scene: SKScene, _ startingSize: CGRect)
    {
        self.GameState = .INIT;
        
        self.Scene = scene;
        
        self.Area = PlayArea(area: startingSize, scene: self.Scene)
        
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
        self.GameState = .LOADED;
    }

    func StartNewGame()
    {
        if(assetsAreLoaded == false)
        {
            print("Error: StartNewGame called before assets are loaded.");
            
            return;
        }
        
        self.MemorySequence = ShapeSequence(withStartingShapeCount: 1);
        self.Area?.addShape(fromListOfShapes: (self.MemorySequence?.GetSequenceShapes())!);
    }
    
    public func VerifyGameStatus()
    {
        if(self.MemorySequence!.IsFinished())
        {
            self.Area!.clear();
            self.MemorySequence!.EvolveSequence();
            self.MemorySequence!.RestartSequence();
            
            self.Area!.addShape(fromListOfShapes: self.MemorySequence!.GetSequenceShapes());
        }
        else if(MemorySequence!.SequenceIsCorrect() == false)
        {
            // Restart
            self.Area!.clear();
            self.MemorySequence!.RestartSequence();
            
            self.Area!.addShape(fromListOfShapes: self.MemorySequence!.GetSequenceShapes());
        }
    }
    
    func Update()
    {
        self.Area!.updateShapes();
    }
    
    func ProcessClick(at point: CGPoint)
    {
        let result = self.Area?.processTouch(at: point);
        
        if(result != ShapesKind.NONE)
        {
            self.MemorySequence?.ShapeClicked(kind: result!);
            
            self.VerifyGameStatus();
        }
    }
    
    func ResizeGame(withFrame frame: CGRect)
    {
        self.Area?.resetSize(frame);
    }
}
