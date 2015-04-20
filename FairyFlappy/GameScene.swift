//
//  GameScene.swift
//  FairyFlappy
//
//  Created by Jessie Pease on 4/14/15.
//  Copyright (c) 2015 Jessie Pease. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    var myLabel: SKLabelNode!
    var sprite: SKSpriteNode!
    var background1: SKSpriteNode!
    var background2: SKSpriteNode!
    
    override init() {
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.size = view.frame.size
        self.myLabel = SKLabelNode(fontNamed:"AppleSDGothicNeo-Light")
        self.myLabel.text = "Tap to Begin";
        self.myLabel.fontSize = 65;
        self.myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(self.myLabel)
        
        
        /*Create fairy sprite*/
        let location = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        sprite = SKSpriteNode(imageNamed:"fairy")
        self.sprite.xScale = 0.30
        self.sprite.yScale = 0.30
        self.sprite.position = location
        self.sprite.physicsBody = SKPhysicsBody(texture: self.sprite.texture, size: self.sprite.size)
        self.sprite.physicsBody?.allowsRotation = false
        self.physicsWorld.gravity.dy = CGFloat(-4.0)
        
        /*Initialize background1*/
        self.background1 = SKSpriteNode(imageNamed: "skybackground.png")
        background1.anchorPoint = CGPointZero
        background1.position = CGPointMake(0, 0)
        background1.zPosition = -15
        self.addChild(background1)
        
        /*Initialize background1*/
        self.background2 = SKSpriteNode(imageNamed: "skybackground.png")
        background2.anchorPoint = CGPointZero
        background2.position = CGPointMake(background1.size.width - 1, 0)
        background2.zPosition = -15
        self.addChild(background2)
        

    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("touches")
        /* Called when a touch begins */
        let thrust = CGFloat(150)
        self.runAction(SKAction.playSoundFileNamed("sparklesound.aiff", waitForCompletion: false))
        
        if (self.myLabel.text != "") {
            
            self.myLabel.text = ""
            
            let physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
            self.physicsBody = physicsBody
            //self.size = self.view!.frame.size
            
            self.addChild(self.sprite)
            
        }
            
        else {
            let upVector = CGVector(dx: 0, dy: thrust)
            self.sprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            let sparkle:SKEmitterNode = SKEmitterNode(fileNamed: "jumpParticle.sks")
            self.sprite.addChild(sparkle)
            println(sparkle.particleLifetime)
            self.sprite.physicsBody?.applyForce(upVector)
            self.runAction(SKAction.waitForDuration(NSTimeInterval(0.4)), completion: { sparkle.removeFromParent() })
        }
        
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        background1.position = CGPointMake(background1.position.x - 2, background1.position.y)
        background2.position = CGPointMake(background2.position.x - 2, background2.position.y)
        
        if(background1.position.x < -background1.size.width)
        {
            background1.position = CGPointMake(background2.position.x + background2.size.width, background2.position.y)
        }
        
        if(background2.position.x < -background2.size.width)
        {
            background2.position = CGPointMake(background1.position.x + background1.size.width, background1.position.y)
            
        }
    }
    
    func rotationHappened() {
        let skView:SKView = self.view!
        skView.scene?.size = skView.frame.size
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        println("rotationhappened")
        //change label and phyiscs body of the screen
        self.sprite.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)

    }
    
}
