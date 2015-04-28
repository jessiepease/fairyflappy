//
//  GameScene.swift
//  FairyFlappy
//
//  Created by Jessie Pease on 4/14/15.
//  Copyright (c) 2015 Jessie Pease. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Fairy   : UInt32 = 0b1       // 1
    static let Obstacle: UInt32 = 0b10      // 2
    static let Screen: UInt32 = 0b100 //4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var myLabel: SKLabelNode!
    var myGameOverLabel: SKLabelNode!
    var sprite: SKSpriteNode!
    var background1: SKSpriteNode!
    var background2: SKSpriteNode!
    var gameOver: Bool!
    
    var obstacleList: [SKSpriteNode]!
    var topObstacleList: [SKSpriteNode]!
    
    var myGameOver :SKScene!
    
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
        self.myLabel.fontSize = 55;
        self.myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(self.myLabel)
        
        /*Create game over scene*/
        myGameOver = GameOverScene(fileNamed: "GameOverScene")
        self.myGameOverLabel = SKLabelNode(fontNamed:"AppleSDGothicNeo-Light")
        self.myGameOverLabel.text = "Game Over!";
        self.myGameOverLabel.fontSize = 55;
        self.myGameOverLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        
        /*Create fairy sprite*/
        let location = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.sprite = SKSpriteNode(imageNamed:"fairy")
        self.sprite.xScale = 0.30
        self.sprite.yScale = 0.30
        self.sprite.position = location
        self.sprite.physicsBody = SKPhysicsBody(texture: self.sprite.texture, size: self.sprite.size)
        self.sprite.physicsBody?.allowsRotation = false
        self.sprite.physicsBody?.linearDamping = 1
        self.sprite.physicsBody?.categoryBitMask = PhysicsCategory.Fairy
        self.sprite.physicsBody?.collisionBitMask = PhysicsCategory.Obstacle
        self.sprite.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle
        
        
        gameOver = false
        
        self.physicsWorld.gravity.dy = CGFloat(-4.0)
        physicsWorld.contactDelegate = self

        
        
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
        
        obstacleList = []
        topObstacleList = []

    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        println("CONTACT!")
        myGameOverLabel.removeFromParent()
        self.addChild(myGameOverLabel)
        //self.runAction(SKAction.waitForDuration(NSTimeInterval(0.5)))
        gameOver = true
        self.runAction(SKAction.waitForDuration(NSTimeInterval(0.5)), completion: { self.view?.presentScene(myGameOver)})
        
        
    }
    
    func spawnObstacle() {
        var imageNames = ["sunflower1.png", "sunflower2.png", "sunflower3.png", "sunflower4.png"]
        var randInt: Int = Int(skRand(lowerBound: CGFloat(0), upperBound: CGFloat(4)))
        var spawnPos = self.frame.width + self.frame.width/2
        
        if obstacleList.count > 0 {
            spawnPos = obstacleList.last!.position.x + self.frame.width/2
        }
        
        var curObstacle: SKSpriteNode = SKSpriteNode(imageNamed: imageNames[randInt])
        curObstacle.xScale = 0.3
        curObstacle.yScale = 0.3
        curObstacle.position = CGPoint(x: spawnPos, y: curObstacle.size.height/2)
        
        curObstacle.physicsBody = SKPhysicsBody(rectangleOfSize: curObstacle.size)
        curObstacle.physicsBody?.affectedByGravity = false
        curObstacle.physicsBody?.dynamic = true
        curObstacle.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        curObstacle.physicsBody?.collisionBitMask = PhysicsCategory.Fairy
        curObstacle.physicsBody?.contactTestBitMask = PhysicsCategory.Fairy
        curObstacle.physicsBody?.allowsRotation = false
        curObstacle.physicsBody?.mass = CGFloat(10000)
        
        obstacleList.append(curObstacle)
        self.addChild(curObstacle)
        
        
    }
    
    func spawnTopObstacle() {
        var randInt: Int = Int(skRand(lowerBound: CGFloat(0), upperBound: CGFloat(4)))
        var spawnPos = self.frame.width
        
        if topObstacleList.count > 0 {
            spawnPos = topObstacleList.last!.position.x + self.frame.width*1.5
        }
        
        var curTopObstacle: SKSpriteNode = SKSpriteNode(imageNamed: "cloud.png")
        curTopObstacle.xScale = 0.09
        curTopObstacle.yScale = 0.09
        curTopObstacle.position = CGPoint(x: spawnPos, y: self.frame.height - curTopObstacle.size.height/2)
        
        curTopObstacle.physicsBody = SKPhysicsBody(rectangleOfSize: curTopObstacle.size)
        curTopObstacle.physicsBody?.affectedByGravity = false
        curTopObstacle.physicsBody?.dynamic = true
        curTopObstacle.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        curTopObstacle.physicsBody?.collisionBitMask = PhysicsCategory.Fairy
        curTopObstacle.physicsBody?.contactTestBitMask = PhysicsCategory.Fairy
        curTopObstacle.physicsBody?.allowsRotation = false
        curTopObstacle.physicsBody?.mass = CGFloat(10000)
        
        topObstacleList.append(curTopObstacle)
        self.addChild(curTopObstacle)
        
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        if (!gameOver) {
            let thrust = CGFloat(150)
            self.runAction(SKAction.playSoundFileNamed("sparklesound.aiff", waitForCompletion: false))
            
            if (self.myLabel.text != "") {
                
                self.myLabel.text = ""
                
                let physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
                physicsBody.collisionBitMask = PhysicsCategory.Fairy
                physicsBody.categoryBitMask = PhysicsCategory.Obstacle
                physicsBody.contactTestBitMask = PhysicsCategory.Fairy
                self.physicsBody = physicsBody
                //self.size = self.view!.frame.size
                
                self.addChild(self.sprite)
                spawnObstacle()
                spawnObstacle()
                spawnObstacle()
                spawnObstacle()
                spawnTopObstacle()
                spawnTopObstacle()
                
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
    
    func skRandf() -> CGFloat {
        return CGFloat(Double(arc4random()) / Double(UINT32_MAX))
    }
    
    func skRand(lowerBound low: CGFloat, upperBound high: CGFloat) -> CGFloat {
        return skRandf() * (high - low) + low
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if (!gameOver) {
            scrollBackground()
            
            var imageNames = ["sunflower1.png", "sunflower2.png", "sunflower3.png", "sunflower4.png"]
            
            for ob in obstacleList {
                ob.position = CGPointMake(ob.position.x - 2, ob.position.y)
                if (ob.position.x < -ob.size.width) {
                    ob.removeFromParent()
                    obstacleList.removeAtIndex(find(obstacleList, ob)!)
                    spawnObstacle()
                }
            }
            for tob in topObstacleList {
                tob.position = CGPointMake(tob.position.x - 4, tob.position.y)
                if (tob.position.x < -tob.size.width) {
                    tob.removeFromParent()
                    topObstacleList.removeAtIndex(find(topObstacleList, tob)!)
                    spawnTopObstacle()
                }
            }
        
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
