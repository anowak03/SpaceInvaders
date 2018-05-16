//
//  GameScene.swift
//  SpaceInvaders2018
//
//  Created by Alexander Nowak on 4/24/18.
//  Copyright © 2018 Alexander Nowak. All rights reserved.
//

import SpriteKit
import GameplayKit
struct PhysicsCategory {
    static let None : UInt32 = 0
    static let All : UInt32 = UInt32.max
    static let Enemy : UInt32 = 0b1
    static let Projectile : UInt32 = 0b10
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let playerFiredBulletName = "straightBullet!"
    let enemyFiredBulletName = "squigglyBullet"
    let kBulletSize = CGSize(width:4, height: 8)
    var topInit = 0
    
    // create player as generic spriteNode variable
    
    var tapQueue = [Int]()
    var player = SKSpriteNode()
    var rightButton = SKSpriteNode()
    var leftButton = SKSpriteNode()
    var shootButtonA = SKSpriteNode()
    var shootButtonB = SKSpriteNode()
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        var projectile = SKSpriteNode()
        let a0 = SKTexture.init(imageNamed: "straightBullet")
        let a1 = SKTexture.init(imageNamed: "straightBullet")
        let straightBullet = SKSpriteNode(imageNamed: "straightBullet")
        let bulletFrames : [SKTexture] = [a0, a1]
        if let name = touchedNode.name
        {
            if name == "RButton"
            {
                print("Touched at \(touch.location(in: self))")
                player.position.x += 16
                
                
            } else if name == "LButton" {
                print("Touched at \(touch.location(in: self))")
                player.position.x -= 16
            } else if name == "SBA" {
                print("Shot fired!")
                projectile = SKSpriteNode (imageNamed: "straightBullet")
                let bulletAnimation = SKAction.animate(with: bulletFrames, timePerFrame: 0.15)
                straightBullet.run(SKAction.repeatForever(bulletAnimation))
            } else if name == "SBB" {
                print ("Shot fired!")
                projectile = SKSpriteNode (imageNamed: "straightBullet")
                let bulletAnimation = SKAction.animate(with: bulletFrames, timePerFrame: 0.15)
                straightBullet.run(SKAction.repeatForever(bulletAnimation))
            }
            
            
        }
        projectile.position = player.position
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        let offset = positionInScene - projectile.position
        if offset.x < 0 {
            return
        }
        
        addChild(projectile)
        let direction = offset.normalized()
        let shootAmount = direction * 1000
        let realDest = projectile.position
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        print("onscreen")
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.tapCount == 1) {
                tapQueue.append(1)
            }
        }
    }
    
    override func didMove(to view: SKView)
    {
        let backgroundMusic = SKAudioNode(fileNamed: "03 Chibi Ninja")
            backgroundMusic.autoplayLooped = true
            addChild(backgroundMusic)
        
        physicsWorld.contactDelegate = self
    
        
        player = self.childNode(withName: "player") as! SKSpriteNode
        
        while topInit < 10
        {
            addEnemyTop()
            
        }
        shootButtonA = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 150, height: 100))
        shootButtonA.name = "SBA"
        shootButtonA.position = CGPoint(x: -435, y: -235)
        shootButtonB = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 150, height: 100))
        shootButtonB.name = "SBB"
        shootButtonB.position = CGPoint(x: 435, y: -235)
        rightButton = SKSpriteNode(color: SKColor.green, size: CGSize(width: 150, height: 100))
        
        
        rightButton.name = "RButton"
        rightButton.position = CGPoint(x: 435, y: -335)
        
        
        rightButton.isUserInteractionEnabled = false
        
        self.addChild(rightButton)
        
        leftButton = SKSpriteNode(color: SKColor.green, size: CGSize(width: 150, height: 100))
        
        
        leftButton.name = "LButton"
        leftButton.position = CGPoint(x: -435, y: -335)
        
        
        leftButton.isUserInteractionEnabled = false
        
        
        
        self.addChild(leftButton)
    }
    func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
        print("Hit")
        projectile.removeFromParent()
        monster.removeFromParent()
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random())/0xFFFFFFFF)
    }
    
    func addEnemyTop() {
        let f0 = SKTexture.init(imageNamed: "topEnemyPositionA")
        let f1 = SKTexture.init(imageNamed: "topEnemyPositionB")
        
        let frames: [SKTexture] = [f0, f1]
        
        // Load the first frame as initialization
        let enemy = SKSpriteNode(imageNamed: "topEnemyPositionA")
        
        //Animate
        let animation = SKAction.animate(with: frames, timePerFrame: 0.4)
        enemy.run(SKAction.repeatForever(animation))
        
        // Physics body (Probably Broken)
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.None
        enemy.xScale = 1
        enemy.yScale = 1
        
        
        // Set position
        enemy.position = CGPoint(x: (-394 + (topInit * 98)) , y: 180 )
        addChild(enemy)
        
        
        topInit += 1
        
    }
    
    
    
    
    
}
     

 
    
    
    


