//
//  HighscoreText.swift
//  Memory Me
//
//  Created by Tristan Dube on 2019-04-06.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import Foundation
import SpriteKit

class HighscoreText : SKNode
{
    public var textLabel: SKLabelNode;
    
    private var fadeInAction: SKAction;
    
    override init() {
        textLabel = SKLabelNode(text: "");
        textLabel.fontSize = 96;
        textLabel.alpha = 0;
        
        let fadeIn = SKAction.fadeIn(withDuration: 1);
        let delay = SKAction.wait(forDuration: 1);
        let fadeOut = SKAction.fadeOut(withDuration: 1);
        
        self.fadeInAction = SKAction.sequence([fadeIn, delay, fadeOut]);

        super.init();
        
        self.addChild(textLabel);
    }
    
    required init?(coder aDecoder: NSCoder) {
        textLabel = SKLabelNode(text: "");
        textLabel.fontSize = 96;
        textLabel.alpha = 0;
        
        let fadeIn = SKAction.fadeIn(withDuration: 1);
        let delay = SKAction.wait(forDuration: 1);
        let fadeOut = SKAction.fadeOut(withDuration: 1);
        
        self.fadeInAction = SKAction.sequence([fadeIn, delay, fadeOut]);

        super.init(coder: aDecoder);

        self.addChild(textLabel);
    }
    
    public func setText(_ scoreAmount: Int)
    {
        self.textLabel.text = "Today's highscore = \(scoreAmount)";
    }
    
    public func temporaryShow()
    {
        textLabel.run(fadeInAction);
    }
}
