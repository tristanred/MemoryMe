//
//  GameScene.swift
//  Memory Me Shared
//
//  Created by Tristan Dube on 2019-01-03.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import SpriteKit

class GameScene: SKScene
{
    // Scene size properties
    var initialWidth: CGFloat = 0;
    var initialHeight: CGFloat = 0;
    
    var scaleFactorX: CGFloat = 0;
    var scaleFactorY: CGFloat = 0;
    
    var Game: MemoryMeGame?;
    
    class func newGameScene() -> GameScene
    {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks");
            abort();
        }
        
        scene.initialWidth = scene.size.width;
        scene.initialHeight = scene.size.height;
        
        // Set the scale mode to scale to fit the window
        //scene.scaleMode = .aspectFill;
        scene.scaleMode = .resizeFill;
        
        return scene;
    }
    
    func setUpScene()
    {
        let myFrame = self.scene!.view!.frame;

        self.Game = MemoryMeGame(self, myFrame);
        
        self.Game?.LoadTextures();
        self.Game?.StartNewGame();
    }
    
    override func didMove(to view: SKView)
    {
        self.setUpScene();
    }
    
    override func didChangeSize(_ oldSize: CGSize)
    {
        let myFrame = self.scene?.view?.frame;
        if(myFrame != nil)
        {
            self.Game?.ResizeGame(withFrame: myFrame!);
        }
        
        self.PrintScaleFactor();
    }
    
    func PrintScaleFactor()
    {
        self.scaleFactorX = self.size.width / self.initialWidth;
        self.scaleFactorY = self.size.height / self.initialHeight;
        
        print("Resolution is \(Int(self.size.width))x\(Int(self.size.height))");
        print("Current Ratio is  \(self.frame.getSizeRatio())");
        //print("Current scale factor : x = \(self.scaleFactorX), y = \(self.scaleFactorY)");
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        self.Game?.Update();
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene
{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches
        {
            self.Game?.ProcessClick(at: t.location(in: self));
        }
    }
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene
{
    override func mouseUp(with event: NSEvent)
    {
        self.Game?.ProcessClick(at: event.location(in: self));
    }
}
#endif
