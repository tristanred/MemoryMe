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
    
    var labelWidthValue: SKLabelNode?;
    var labelHeightValue: SKLabelNode?;
    
    var Game: MemoryMeGame?;
    
    class func newGameScene() -> GameScene
    {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks");
            abort();
        }
        
        let scrSize = UIScreen.main.bounds.size;
        
        // Set the initial size depending on the device layout
        if(isTallScreen(width: scrSize.width, height: scrSize.height))
        {
            // iPhone X Resolution
            scene.size.width = 1125;
            scene.size.height = 2436;
        }
        else
        {
            // iPad resolution
            scene.size.width = 2048 / 2;
            scene.size.height = 2732 / 2;
        }
        
        scene.initialWidth = scene.size.width;
        scene.initialHeight = scene.size.height;
        
        scene.labelWidthValue = scene.childNode(withName: "//WidthValue") as? SKLabelNode;
        scene.labelHeightValue = scene.childNode(withName: "//HeightValue") as? SKLabelNode;
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFit;
        //scene.scaleMode = .resizeFill;
        
        return scene;
    }
    
    
    func setUpScene()
    {
        self.Game = MemoryMeGame(self, GetViewFrame());
        
        self.Game?.LoadTextures();
        self.Game?.StartNewGame();
    }
    
    override func didMove(to view: SKView)
    {
        self.setUpScene();
    }
    
    override func didChangeSize(_ oldSize: CGSize)
    {
        self.Game?.ResizeGame(withFrame: self.GetViewFrame());
        self.UpdateDebugInfo();
    }
    
    #if os(OSX)
    override func keyUp(with event: NSEvent)
    {
        if(event.keyCode == 49)
        {
            self.Game?.debugKeyPressed();
        }
    }
    #endif
    
    /**
     * Get a rectangle corresponding to the size of the view.
     *
     * Returns a Zero rectangle if the view frame does not exist.
     */
    func GetViewFrame() -> CGRect
    {
        var r = CGRect(origin: CGPoint(x: 0, y: 0), size: self.size);
        r = r.insetBy(dx: 0, dy: 20);
        
        return r;
    }
    
    func UpdateDebugInfo()
    {
        self.labelWidthValue?.text = "\(round(self.size.width))";
        self.labelHeightValue?.text = "\(round(self.size.height))";
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        self.Game?.Update();
    }
}

func isTallScreen(width: CGFloat, height: CGFloat) -> Bool
{
    if(width > height)
    {
        let ratio: CGFloat = width / height;
        
        if(ratio > 1.77)
        {
            return true;
        }
    }
    else
    {
        let ratio: CGFloat = height / width;
        
        if(ratio > 1.77)
        {
            return true;
        }
    }
    
    return false;
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
