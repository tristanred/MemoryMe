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

    var movingTestShape: SKSpriteNode?;
    
    let left: Int = -500;
    let right: Int = 500;
    let top: Int = -500;
    let bottom: Int = 500;

    var shapeTextures: [SKTexture] = [];
    var shapesOnScreen: [SKSpriteNode] = [];
    var shapeVelocities: [(CGFloat, CGFloat)] = [];
    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    func setUpScene() {
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        self.shapeTextures = [SKTexture]();
        self.shapesOnScreen = [SKSpriteNode]();
        
        let circleTexture = SKTexture(imageNamed: "0_Circle_256.png");
        let triangleTexture = SKTexture(imageNamed: "3_Triangle_256.png");
        let squarexture = SKTexture(imageNamed: "1_Square_256.png");
        let diamondTexture = SKTexture(imageNamed: "2_Diamond_256.png");
        
        self.shapeTextures.append(circleTexture);
        self.shapeTextures.append(triangleTexture);
        self.shapeTextures.append(squarexture);
        self.shapeTextures.append(diamondTexture);
        
        let one = SKSpriteNode(texture: circleTexture);
        one.position = CGPoint(x: -400, y: -400);
        self.shapeVelocities.append((5, 5));
        self.shapesOnScreen.append(one);
        self.addChild(one);
        
        let two = SKSpriteNode(texture: triangleTexture);
        two.position = CGPoint(x: -400, y: 400);
        self.shapeVelocities.append((5, 5));
        self.shapesOnScreen.append(two);
        self.addChild(two);
        
        let three = SKSpriteNode(texture: squarexture);
        three.position = CGPoint(x: 400,y: -400);
        self.shapeVelocities.append((5, 5));
        self.shapesOnScreen.append(three);
        self.addChild(three);
        
        let four = SKSpriteNode(texture: diamondTexture);
        four.position = CGPoint(x: 400, y: 400);
        self.shapeVelocities.append((5, 5));
        self.shapesOnScreen.append(four);
        self.addChild(four);
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 4.0
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
            
            #if os(watchOS)
                // For watch we just periodically create one of these and let it spin
                // For other platforms we let user touch/mouse events create these
                spinnyNode.position = CGPoint(x: 0.0, y: 0.0)
                spinnyNode.strokeColor = SKColor.red
                self.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 2.0),
                                                                   SKAction.run({
                                                                       let n = spinnyNode.copy() as! SKShapeNode
                                                                       self.addChild(n)
                                                                   })])))
            #endif
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
        
        for i in 0...self.shapesOnScreen.count-1
        {
            self.shapesOnScreen[i].position.x += self.shapeVelocities[i].0;
            self.shapesOnScreen[i].position.y += self.shapeVelocities[i].1;
        }
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.green)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.blue)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }
    }
    
   
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        self.makeSpinny(at: event.location(in: self), color: SKColor.green)
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.makeSpinny(at: event.location(in: self), color: SKColor.blue)
    }
    
    override func mouseUp(with event: NSEvent) {
        self.makeSpinny(at: event.location(in: self), color: SKColor.red)
    }

}
#endif

