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
    private let missileCategory: UInt32 = 0x1 << 0   //000001 in binary
    private let enemyCategory: UInt32   = 0x1 << 1   //000010 in binary
    private let heroCategory: UInt32 = 0x1 << 2      //000100 in binary
    private let noneCategory: UInt32 = 0
    
    //Sprite Usages
    var hero:SKNode!
    var Gun: SKSpriteNode!
    var enemy: SKSpriteNode!
    var Boss: SKSpriteNode!
    
    //Button Usages
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
       // hero.physicsBody?.collisionBitMask = enemyCategory
        
        
        for i in 1...5 {
            spawnenemy()
        }
        
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
                let n = childNodeWithName("//hero")
                    for touch in touches {
                        let location = touch.locationInNode(n!.parent!)
                        if n!.containsPoint(location) {
                            let dx = CGFloat(1000)
                            let dy = CGFloat(5000)
                            if location.x > n!.position.x / 2 {
                                n!.physicsBody!.applyImpulse(CGVector(dx: -dx , dy: dy))
                            } else {
                                n!.physicsBody!.applyImpulse(CGVector(dx: dx , dy: dy))
                            }
                        } else {
                            let nodePos = self.convertPoint(n!.position, fromNode: n!.parent!)
                            
                            let MissileTexture = SKTexture(imageNamed: "Missile")
                            let Missile = SKSpriteNode(texture: MissileTexture)
                            Missile.position = nodePos
                            Missile.setScale(0.25)
                            Missile.name = "Missile"
                            self.addChild(Missile)
                            
                            let move = SKAction.moveToX(frame.width, duration: 1)
                            let remove = SKAction.removeFromParent()
                            let seq = SKAction.sequence([ move, remove ])
                            Missile.runAction(seq)
                            
                        }
                }
            }
       }
                
               
                
                
                
                
               /* let missilePause = hero.convertPoint(hero.position, toNode: self)
                Missile.position = missilePause
                print("missilePause \(missilePause)")
                
                let action = SKAction.moveToX(self.size.width, duration: 0.8)
                let actionDone = SKAction.removeFromParent()
                Missile.runAction(SKAction.sequence([action, actionDone]))
                
                
                
                Missile.physicsBody = SKPhysicsBody(rectangleOfSize: Missile.size)
                
                
                Missile.physicsBody!.categoryBitMask = missileCategory
                Missile.physicsBody!.collisionBitMask = enemyCategory
                Missile.physicsBody!.contactTestBitMask = enemyCategory
                
                Missile.physicsBody!.affectedByGravity = false
                Missile.physicsBody!.dynamic = false*/
                
                
            
       
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
    func spawnenemy() {
        var enemyTexture = SKTexture(imageNamed: "fireball")
        
        let enemy = SKSpriteNode(texture: enemyTexture)
        enemy.setScale(0.05)
        enemy.name = "fireball"
        
        //Mod to make enemy appear anywhere 0 to 319
        let x: CGFloat = CGFloat(arc4random() % 260)+30
        let y: CGFloat = CGFloat(arc4random() % 407)+101
        
        enemy.position = CGPoint(x: x, y: y)
        
        var enemyPhysicsSize = CGSize(width: enemy.size.width,height: enemy.size.height)
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemyPhysicsSize)
        enemy.physicsBody?.dynamic = false
        
        enemy.physicsBody!.categoryBitMask = enemyCategory
        enemy.physicsBody!.contactTestBitMask = noneCategory
        enemy.physicsBody!.collisionBitMask = heroCategory
        
        self.addChild(enemy)
        
    }
    
    
    /*func shoot(){
        let MissileTexture = SKTexture(imageNamed: "Missile")
        
        let Missile = SKSpriteNode(texture: MissileTexture)
        Missile.setScale(0.5)
        Missile.name = "Missile"
        
        if let n = childNodeWithName("//hero") {
            for touch in touches {
                print(n.position)
                let location = touch.locationInNode(n.parent!)
                if n.containsPoint(location) {
                    let dx = CGFloat(1000)
                    let dy = CGFloat(5000)
                    if location.x > n.position.x / 2 {
                        n.physicsBody!.applyImpulse(CGVector(dx: -dx , dy: dy))
                    } else {
                        n.physicsBody!.applyImpulse(CGVector(dx: dx , dy: dy))
                    }
                    
                } else {
                    let nodePos = self.convertPoint(n.position, fromNode: n.parent!)
                    
                    let size = CGSize(width: 20, height: 20)
                    let bullet = SKSpriteNode(color: UIColor.greenColor(), size: size)
                    bullet.position = nodePos
                    addChild(bullet)
                    
                    let move = SKAction.moveToX(frame.width, duration: 1)
                    let remove = SKAction.removeFromParent()
                    let seq = SKAction.sequence([ move, remove ])
                    bullet.runAction(seq) */
                    
    
}
        
     
    
    

