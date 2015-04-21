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
    var obstacle1: SKSpriteNode!
    var obstacle2: SKSpriteNode!
    var obstacle3: SKSpriteNode!
    var obstacle4: SKSpriteNode!
    
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
        self.sprite = SKSpriteNode(imageNamed:"fairy")
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
        
        /*Create sunflower1 sprite*/
        self.obstacle1 = SKSpriteNode(imageNamed: "sunflower1.png")
        self.obstacle1.xScale = 0.3
        self.obstacle1.yScale = 0.3
        self.obstacle1.position = CGPoint(x: self.frame.width, y: self.obstacle1.size.height/2)
        
        /*Create sunflower2 sprite*/
        self.obstacle2 = SKSpriteNode(imageNamed: "sunflower4.png")
        self.obstacle2.xScale = 0.3
        self.obstacle2.yScale = 0.3
        self.obstacle2.position = CGPoint(x: self.frame.width + self.frame.width/2, y: self.obstacle1.size.height/2)
        
        /*Create sunflower3 sprite*/
        self.obstacle3 = SKSpriteNode(imageNamed: "sunflower3.png")
        self.obstacle3.xScale = 0.3
        self.obstacle3.yScale = 0.3
        self.obstacle3.position = CGPoint(x: self.frame.width * 2, y: self.obstacle3.size.height/2)
        
        /*Create sunflower4 sprite*/
        self.obstacle4 = SKSpriteNode(imageNamed: "sunflower2.png")
        self.obstacle4.xScale = 0.3
        self.obstacle4.yScale = 0.3
        self.obstacle4.position = CGPoint(x: self.frame.width * 2 + self.frame.width/2, y: self.obstacle4.size.height/2)
        
        
        

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
            self.addChild(self.obstacle1)
            self.addChild(self.obstacle2)
            self.addChild(self.obstacle3)
            self.addChild(self.obstacle4)
            
        }
            
        else {
            let upVector = CGVector(dx: 0, dy: thrust)
            self.sprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            let sparkle:SKEmitterNode = SKEmitterNode(fileNamed: "jumpParticle.sks")
            self.sprite.addChild(sparkle)
            println(sparkle.particleLifetime)
            self.sprite.physicsBody?.applyForce(upVector)
            self.runAction(SKAction.waitForDuration(NSTimeInterval(0.4)), completion: { sparkle.removeFromParent() })
            self.sprite.texture = SKTexture(imageNamed: "fairy2.png")
            self.runAction(SKAction.waitForDuration(NSTimeInterval(0.25)), completion: { self.sprite.texture = SKTexture(imageNamed: "fairy.png") })
        }
        
        
    }
    
    func scrollBackground() {
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
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        scrollBackground()
        
        //var imageNames = ["sunflower1.png", "sunflower2.png", "sunflower3.png", "sunflower4.png"]
        
        obstacle1.position = CGPointMake(obstacle1.position.x - 2, obstacle1.position.y)
        obstacle2.position = CGPointMake(obstacle2.position.x - 2, obstacle2.position.y)
        obstacle3.position = CGPointMake(obstacle3.position.x - 2, obstacle3.position.y)
        obstacle4.position = CGPointMake(obstacle4.position.x - 2, obstacle4.position.y)
        
        if(obstacle1.position.x < -obstacle1.size.width)
        {
            obstacle1.position = CGPointMake(obstacle4.position.x + self.frame.width/2, obstacle1.position.y)
        }
        
        if(obstacle2.position.x < -obstacle2.size.width)
        {
            obstacle2.position = CGPointMake(obstacle1.position.x + self.frame.width/2, obstacle2.position.y)
            
        }
        
        if(obstacle3.position.x < -obstacle3.size.width)
        {
            obstacle3.position = CGPointMake(obstacle2.position.x + self.frame.width/2, obstacle3.position.y)
            
        }
        
        if(obstacle4.position.x < -obstacle4.size.width)
        {
            obstacle4.position = CGPointMake(obstacle3.position.x + self.frame.width/2, obstacle4.position.y)
            
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
