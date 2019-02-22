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
        
        sequence = ShapeSequence(withStartingShapeCount: 1);
        
        self.areaZone!.addShape(fromListOfShapes: sequence!.GetSequenceShapes());
        
//        let circleTeture = ShapeTextureMap[.CIRCLE];
//        let triangleTexture = ShapeTextureMap[.TRIANGLE];
//        let squareTexture = ShapeTextureMap[.SQUARE];
//        let diamondTexture = ShapeTextureMap[.DIAMOND];
//
//        self.areaZone!.addShape(newShape: GameShape(texture: circleTeture));
//        self.areaZone!.addShape(newShape: GameShape(texture: triangleTexture));
//        self.areaZone!.addShape(newShape: GameShape(texture: squareTexture));
//        self.areaZone!.addShape(newShape: GameShape(texture: diamondTexture));
    }
    
    public func VerifyGameStatus()
    {
        if(sequence!.IsFinished())
        {
            self.areaZone!.clear();
            self.sequence!.EvolveSequence();
            self.sequence!.RestartSequence();
            
            self.areaZone!.addShape(fromListOfShapes: sequence!.GetSequenceShapes());
        }
        else if(sequence!.SequenceIsCorrect() == false)
        {
            // Restart
            self.areaZone!.clear();
            self.sequence!.RestartSequence();
            
            self.areaZone!.addShape(fromListOfShapes: sequence!.GetSequenceShapes());
            
        }
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
        for t in touches
        {
            let result = self.areaZone?.processTouch(at: t.location(in: self));
            
            if(result != ShapesKind.NONE)
            {
                self.sequence?.ShapeClicked(kind: result!);
                
                self.VerifyGameStatus();
            }
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
        let result = self.areaZone?.processTouch(at: event.location(in: self));
        
        if(result != ShapesKind.NONE)
        {
            self.sequence?.ShapeClicked(kind: result!);
            
            self.VerifyGameStatus();
        }

        self.makeSpinny(at: event.location(in: self), color: SKColor.red)
    }
}
#endif
