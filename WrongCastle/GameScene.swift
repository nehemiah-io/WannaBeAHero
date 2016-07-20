//
//  GameScene.swift
//  WrongCastle
//
//  Created by MacBook Pro  on 7/13/16.
//  Copyright (c) 2016 NiidMo Games. All rights reserved.
//
    






    
import SpriteKit
    
class GameScene: SKScene {
    
    // Physics body category bitmasks
    // ------------------------------
    // We'll use these to determine missle-fire collisions
    private let missileCategory: UInt32 = 0x1 << 0   // 00000000000000000000000000000001 in binary
    private let EnemyCategory: UInt32   = 0x1 << 1   // 00000000000000000000000000000010 in binary
    private let heroCategory: UInt32 = 0x1 << 2      //00000000000000000000000000000100 in binary
    private let noneCategory: UInt32 = 0
    
    
    var hero:SKNode!
    var Gun: SKSpriteNode!
   
    var Boss: SKSpriteNode!
    var LeftButton: SKSpriteNode!
    var RightButton: SKSpriteNode!
    var JumpButton: SKSpriteNode!
    var ShootButton: SKSpriteNode!
    var isTouching = false
    var direction = 1
    
 
    
    
    override func didMoveToView(view: SKView) {
            /* Set up your scene here */
        hero = self.childNodeWithName("//hero")
        hero.physicsBody?.categoryBitMask = heroCategory
       // hero.physicsBody?.collisionBitMask = EnemyCategory
        
    }
    
    
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
       
        
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            if (node.name == "LeftButton") {
                // logic for left button touch here:
                // hero.physicsBody?.applyImpulse(CGVector(dx: -20, dy: 0))
                isTouching = true
                direction = -1
            
            } else if (node.name == "JumpButton"){
                // jump logic
                //hero.position = CGPoint(x: hero.position.x, y:hero.position.y+50)
                hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 200))
                
            } else if (node.name == "RightButton") {
            //  logic for right button touch here:
                // hero.position = CGPoint(x:hero.position.x+20, y:hero.position.y)
                isTouching = true
                direction = 1
                
            } else if (node.name == "ShootButton"){
                //Implement missile function
                let Hero_Ref = self.childNodeWithName("Hero_Ref")
                let Missile = SKSpriteNode(imageNamed: "Missile")
                Missile.zPosition = 0
                
                
                let missilePause = hero.position
                Missile.position = missilePause
                print("missilePause \(missilePause)")
                
                let action = SKAction.moveToX(self.size.width, duration: 0.8)
                let actionDone = SKAction.removeFromParent()
                //Missile.runAction(SKAction.sequence([action, actionDone]))
                
                Missile.physicsBody = SKPhysicsBody(rectangleOfSize: Missile.size)
                
                Missile.physicsBody?.categoryBitMask = missileCategory
                Missile.physicsBody?.collisionBitMask = noneCategory
                Missile.physicsBody?.contactTestBitMask = EnemyCategory
                
                Missile.physicsBody?.affectedByGravity = false
                Missile.physicsBody?.dynamic = false
                self.addChild(Missile)

                
            }
        }
    }
    
    
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?){
        
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?){
       isTouching = false
    }
        
    override func update(currentTime: CFTimeInterval) {
            /* Called before each frame is rendered */
        if isTouching {
            hero.physicsBody?.applyImpulse(CGVector(dx: 5 * direction, dy: 0))
            
        }
    }
}