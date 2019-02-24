//
//  GameScene.swift
//  Memory Me Shared
//
//  Created by Tristan Dube on 2019-01-03.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    fileprivate var label : SKLabelNode?
    fileprivate var spinnyNode : SKShapeNode?
    
    var scaleXLabel: SKLabelNode?;
    var scaleYLabel: SKLabelNode?;

    var sequence: ShapeSequence?;
    var areaZone: PlayArea?;
    var Game: MemoryMeGame?;
    
    class func newGameScene() -> GameScene
    {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        //scene.scaleMode = .aspectFill;
        scene.scaleMode = .resizeFill;
        
        return scene;
    }
    
    func setUpScene()
    {
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        self.scaleXLabel = self.childNode(withName: "//ScaleX_Label") as? SKLabelNode;
        self.scaleYLabel = self.childNode(withName: "//ScaleY_Label") as? SKLabelNode;
        
        let myFrame = self.scene!.view!.frame;

        self.Game = MemoryMeGame(self, myFrame);
        
        self.Game?.LoadTextures();
        self.Game?.StartNewGame();
        
    }
    
    #if os(watchOS)
    override func sceneDidLoad()
    {
        self.setUpScene()
    }
    #else
    override func didMove(to view: SKView)
    {
        self.setUpScene()
    }
    
    override func didChangeSize(_ oldSize: CGSize)
    {
        let myFrame = self.scene?.view?.frame;
        if(myFrame != nil)
        {
            self.Game?.ResizeGame(withFrame: myFrame!);
        }
    }
    #endif
    
    override func update(_ currentTime: TimeInterval)
    {
        // Called before each frame is rendered
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
