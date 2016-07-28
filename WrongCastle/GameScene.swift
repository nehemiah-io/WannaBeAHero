//
//  GameScene.swift
//  WrongCastle
//
//  Created by MacBook Pro  on 7/13/16.
//  Copyright (c) 2016 NiidMo Games. All rights reserved.
//


    
import SpriteKit
    
class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameState: GameSceneState = .Active
    
    
    enum GameSceneState {
        case Active, GameOver
    }

    
    
    // Physics body category bitmasks
    // ------------------------------
    // We'll use these to determine missle-fire collisions
    private let missileCategory: UInt32 = 0b1       //000001 in binary
    private let enemyCategory: UInt32   = 0b10      //000010 in binary
    private let heroCategory: UInt32    = 0b100     //000100 in binary
    private let noneCategory: UInt32    = 0         //000000
    
    //Sprite Usages
    var hero:SKNode!
    var missile: SKSpriteNode!
    var Boss: SKSpriteNode!
    
    //Platform code
    var platform: SKSpriteNode!
    var platformLayer: SKNode!
    var spawnTimer: CFTimeInterval = 0
    
    //Button Usages
    var LeftButton: SKSpriteNode!
    var RightButton: SKSpriteNode!
    var JumpButton: SKSpriteNode!
    var ShootButton: SKSpriteNode!
    var isTouching = false
    var direction = 1
    
   //Scrolling World
    let scrollSpeed: CGFloat = 100
    let fixedDelta: CFTimeInterval = 1.0/60.0 /* 60 FPS */
    var ScrollLayer: SKNode!
    var sinceTouch : CFTimeInterval = 0
   
    //UI controls
    var buttonRestart: MSButtonNode!
    var scoreLabel: SKLabelNode!
    var points = 0
    
    
    
func scrollWorld() {
        /* Scroll World */
        ScrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        for ground in ScrollLayer.children as! [SKSpriteNode] {
            
            /* Get ground node position, convert node position to scene space */
        let groundPosition = ScrollLayer.convertPoint(ground.position, toNode: self)
            
            /* Check if ground sprite has left the scene */
        if groundPosition.x <= -ground.size.width / 2 {
                /* Reposition ground sprite to the second starting position */
        let newPosition = CGPointMake( (self.size.width / 2) + ground.size.width, groundPosition.y)
                
                /* Convert new node position back to scroll layer space */
                ground.position = self.convertPoint(newPosition, toNode: ScrollLayer)
            }
        }
    }

    
    
    
    
    
func didBeginContact(contact: SKPhysicsContact!){
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == missileCategory | enemyCategory {
            // missile hit enemy
            print("missile hit enemy")
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            points += 1
            
            scoreLabel.text = String(points)
            
            return
            
            
        } else if collision == heroCategory | enemyCategory {
            // hero ran into enemy
            contact.bodyA.node?.removeFromParent()
            print(" hero hit enemy")
            gameState = .GameOver
            
            
            
            
            /* Stop hero animation */
            hero.removeAllActions()
            let heroDeath = SKAction.runBlock({
                
                
                /* Stop hero from colliding with anything else */
                self.hero.physicsBody?.collisionBitMask = self.noneCategory
                
            })
            
            /* Run action */
            hero.runAction(heroDeath)
            
            /* Show restart button */
            buttonRestart.state = .Active
                    }
}
    
func spawnenemies() {
    
        for i in 1...10 {
            self.spawnenemy()
            
        }
    }
    
    
func spawnenemy() {
        let enemyTexture = SKTexture(imageNamed: "fireball")
        
        let enemy = SKSpriteNode(texture: enemyTexture)
        enemy.setScale(0.05)
        enemy.name = "fireball"
        
        //Mod to make enemy appear anywhere 0 to 319
        let x: CGFloat = CGFloat(arc4random() % 260)+30
        let y: CGFloat = CGFloat(arc4random() % 407)+101
        
        enemy.position = CGPoint(x: x, y: y)
        
        let enemyPhysicsSize = CGSize(width: enemy.size.width,height: enemy.size.height)
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemyPhysicsSize)
        enemy.physicsBody?.dynamic = true
        enemy.physicsBody?.affectedByGravity =  false
        
        enemy.physicsBody!.categoryBitMask = enemyCategory
        enemy.physicsBody!.contactTestBitMask = missileCategory | heroCategory
        enemy.physicsBody!.collisionBitMask = heroCategory
        
        if enemy.position != hero.position{
            
            
            
        }
        
        self.addChild(enemy)
        
    }
    
override func didMoveToView(view: SKView) {
        /* Set up your scene here */
        
        physicsWorld.contactDelegate = self
        
        hero = self.childNodeWithName("//hero")
        
        hero.physicsBody!.categoryBitMask = heroCategory
        hero.physicsBody!.collisionBitMask = enemyCategory
        hero.physicsBody!.contactTestBitMask =  enemyCategory
        
        //scrolling initializer
        ScrollLayer = self.childNodeWithName("ScrollLayer")
        
        platformLayer = self.childNodeWithName("platformLayer")
    
       //Restart Button UI
        buttonRestart = self.childNodeWithName("buttonRestart") as! MSButtonNode
        buttonRestart.state = .Hidden
        
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        buttonRestart.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFill
            
            /* Restart game scene */
            skView.presentScene(scene)

           
        }
    
        spawnenemies()
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
                        
                        guard let n = n else {
                            return
                        }
                        
                        
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
                            
                            let MissileTexture = SKTexture(imageNamed: "Missile")
                            let Missile = SKSpriteNode(texture: MissileTexture)
                            
                            Missile.physicsBody = SKPhysicsBody(rectangleOfSize: MissileTexture.size())
                            
                            Missile.physicsBody!.categoryBitMask = missileCategory
                            Missile.physicsBody!.collisionBitMask = noneCategory
                            Missile.physicsBody!.contactTestBitMask = enemyCategory
                            
                            Missile.physicsBody!.affectedByGravity = false
                            
                            
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
    }

    
override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?){
       isTouching = false
    }
        
override func update(currentTime: CFTimeInterval) {
        if gameState != .Active { return }

        
            /* Called before each frame is rendered */
        if isTouching {
            hero.physicsBody?.applyImpulse(CGVector(dx: 5 * direction, dy: 0))
        }
        sinceTouch+=fixedDelta
        scrollWorld()
        
        spawnTimer+=fixedDelta
    
    var enemycount = 0
    var spawnNewenemies = true
    enumerateChildNodesWithName("fireball") { (node, stop) in
        enemycount += 1
        if enemycount > 4{
            spawnNewenemies = false
            stop.memory = true
        }
    }
    if spawnNewenemies {
        spawnenemies()
    }
    
    
   
    
    
    }
    
        
  
    }
