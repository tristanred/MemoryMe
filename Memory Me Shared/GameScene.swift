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

    var areaZone: PlayArea?;
    
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
        self.areaZone = PlayArea(area: myFrame, scene: self);
        
        InitializeTextureMap(withTextureSet: ShapeAssetsX128);
        
        let circleTeture = ShapeTextureMap[.CIRCLE];
        let triangleTexture = ShapeTextureMap[.TRIANGLE];
        let squarexture = ShapeTextureMap[.SQUARE];
        let diamondTexture = ShapeTextureMap[.DIAMOND];
//        let circleTeture = SKTexture(imageNamed: "0_Circle_128.png");
//        let triangleTexture = SKTexture(imageNamed: "3_Triangle_128.png");
//        let squarexture = SKTexture(imageNamed: "1_Square_128.png");
//        let diamondTexture = SKTexture(imageNamed: "2_Diamond_128.png");
        
        self.areaZone!.addShape(newShape: GameShape(texture: circleTeture));
        self.areaZone!.addShape(newShape: GameShape(texture: triangleTexture));
        self.areaZone!.addShape(newShape: GameShape(texture: squarexture));
        self.areaZone!.addShape(newShape: GameShape(texture: diamondTexture));
    }
    
    #if os(watchOS)
    override func sceneDidLoad() {
        self.setUpScene()
    }
    #else
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        let myFrame = self.scene?.view?.frame;
        if(myFrame != nil)
        {
            self.areaZone!.resetSize(myFrame!);
        }
    }
    #endif

    func makeSpinny(at pos: CGPoint, color: SKColor) {
        if let spinny = self.spinnyNode?.copy() as! SKShapeNode? {
            spinny.position = pos
            spinny.strokeColor = color
            self.addChild(spinny)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        self.areaZone!.updateShapes();
        
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene
{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
//        if let label = self.label
//        {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
        
        for t in touches
        {
            self.areaZone?.processTouch(at: t.location(in: self));
            //self.makeSpinny(at: t.location(in: self), color: SKColor.green)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches
        {
            //self.makeSpinny(at: t.location(in: self), color: SKColor.blue)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
//        for t in touches
//        {
//            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
//        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
//        for t in touches
//        {
//            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
//        }
    }
    
   
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene
{
    override func mouseDown(with event: NSEvent)
    {
//        if let label = self.label
//        {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
        
        
        // self.makeSpinny(at: event.location(in: self), color: SKColor.green)
    }
    
    override func mouseDragged(with event: NSEvent)
    {
        //self.makeSpinny(at: event.location(in: self), color: SKColor.blue)
    }
    
    override func mouseUp(with event: NSEvent)
    {
        self.areaZone?.processTouch(at: event.location(in: self));
        
        //self.makeSpinny(at: event.location(in: self), color: SKColor.red)
    }

}
#endif
