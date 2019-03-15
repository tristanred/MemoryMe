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
        
        scene.initialWidth = scene.size.width;
        scene.initialHeight = scene.size.height;
        
        scene.labelWidthValue = scene.childNode(withName: "//WidthValue") as? SKLabelNode;
        scene.labelHeightValue = scene.childNode(withName: "//HeightValue") as? SKLabelNode;
        
        // Set the scale mode to scale to fit the window
        //scene.scaleMode = .aspectFill;
        scene.scaleMode = .resizeFill;
        
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
