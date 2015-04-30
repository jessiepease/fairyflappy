//
//  GameOverScene.swift
//  FairyFlappy
//
//  Created by Jessie Pease on 4/27/15.
//  Copyright (c) 2015 Jessie Pease. All rights reserved.
//

import SpriteKit


class GameOverScene: SKScene {
    
    var restartScene :SKScene!
    var background: SKSpriteNode!
    var myLabel: SKLabelNode!
    var allowedToTap: Bool!
    var scoreLabel: SKLabelNode!
    var currentScore: Int!
    var highscore1: SKLabelNode!
    var highscore2: SKLabelNode!
    var highscore3: SKLabelNode!
    
    
    override func didMoveToView(view: SKView) {
        println("YAY! Loadedddddd")
        
        allowedToTap = false
        self.size = view.frame.size
        
        /*Initialize restart scene*/
        restartScene = GameScene.unarchiveFromFile("GameScene") as? GameScene
        
        /*Initialize background*/
        self.background = SKSpriteNode(imageNamed: "rainbowforest.jpg")
        background.anchorPoint = CGPointZero
        background.position = CGPointMake(-frame.size.width, 0)
        background.zPosition = -15
        background.size = CGSize(width: frame.size.width*2, height: frame.size.height)
        self.addChild(background)
        
        self.runAction(SKAction.waitForDuration(NSTimeInterval(1.0)), completion: {self.labelHelper()})
    }
    
    func labelHelper() {
        var defaults = NSUserDefaults.standardUserDefaults()
        
        self.myLabel = SKLabelNode(fontNamed:"AppleSDGothicNeo-Light")
        self.myLabel.text = "Tap to Restart";
        self.myLabel.fontSize = 55;
        self.myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y: self.frame.height*2/3);
        self.addChild(myLabel)
        
        self.scoreLabel = SKLabelNode(fontNamed:"AppleSDGothicNeo-Light")
        let toPrint = "Score: " + String(currentScore)
        self.scoreLabel.text = toPrint
        self.scoreLabel.fontSize = 55;
        self.scoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y: self.frame.height/3);
        self.addChild(scoreLabel)
        
        self.highscore1 = SKLabelNode(fontNamed:"AppleSDGothicNeo-Light")
        let toPrint1 = "Top score 1: " + defaults.stringForKey("highscore1")!
        self.highscore1.text = toPrint1
        self.highscore1.fontSize = 20;
        self.highscore1.position = CGPoint(x: self.frame.width/2, y: self.frame.height*3/5);
        self.addChild(highscore1)
        
        self.highscore2 = SKLabelNode(fontNamed:"AppleSDGothicNeo-Light")
        let toPrint2 = "Top score 2: " + defaults.stringForKey("highscore2")!
        self.highscore2.text = toPrint2
        self.highscore2.fontSize = 20;
        self.highscore2.position = CGPoint(x: self.frame.width/2, y: self.frame.height*3/5 - 25);
        self.addChild(highscore2)
        
        self.highscore3 = SKLabelNode(fontNamed:"AppleSDGothicNeo-Light")
        let toPrint3 = "Top score 3: " + defaults.stringForKey("highscore3")!
        self.highscore3.text = toPrint3
        self.highscore3.fontSize = 20;
        self.highscore3.position = CGPoint(x: self.frame.width/2, y: self.frame.height*3/5 - 50);
        self.addChild(highscore3)
        
        self.allowedToTap = true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if ((self.allowedToTap) == true) {
            self.view?.presentScene(restartScene)
        }
    }
    
}