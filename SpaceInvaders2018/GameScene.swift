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
    
    let playerFiredBulletName = "straightBullet"
    let enemyFiredBulletName = "squigglyBullet"
    let kBulletSize = CGSize(width:4, height: 8)
    var topInit = 0
    var middleInit = 0
    var middleInitB = 0
    var bottomInit = 0
    var bottomInitB = 0
    
    // create player as generic spriteNode variable
    
    var tapQueue = [Int]()
    var player = SKSpriteNode()
    var rightButton = SKSpriteNode()
    var leftButton = SKSpriteNode()
    var shootButtonA = SKSpriteNode()
    var shootButtonB = SKSpriteNode()
    let f0 = SKTexture.init(imageNamed: "topEnemyPositionA")
    let f1 = SKTexture.init(imageNamed: "topEnemyPositionB")
    let f2 = SKTexture.init(imageNamed: "middleEnemyPositionA")
    let f3 = SKTexture.init(imageNamed: "middleEnemyPositionB")
    let f4 = SKTexture.init(imageNamed: "topEnemyPositionA")
    let f5 = SKTexture.init(imageNamed: "topEnemyPositionB")
    let topEnemy = SKSpriteNode(imageNamed: "topEnemyPositionA")
    let middleEnemy = SKSpriteNode(imageNamed: "middleEnemyPositionA")
    let bottomEnemy = SKSpriteNode(imageNamed: "bottomEnemyPositionA")
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        var projectile = SKSpriteNode()
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        if let name = touchedNode.name
        {
            if name == "LButton" {
                print("Touched at \(touch.location(in: self))")
                player.position.x -= 24
            }
            
            if name == "RButton"
            {
                print("Touched at \(touch.location(in: self))")
                player.position.x += 24
            }
            if name == "SBA" || name == "SBB" {
                print("Touched at \(touch.location(in: self))")
                print("Shot fired!")
                projectile.position = player.position
                print(player.position)
                projectile = SKSpriteNode(imageNamed: "straightBullet")
                projectile.position = player.position
                print(projectile.position)
                addChild(projectile)
                let actionMove = SKAction.moveTo(y: 384, duration: 2.0)
                let actionMoveDone = SKAction.removeFromParent()
                projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
                
            }
//            projectileDidCollideWithMonster(projectile: projectile, monster: topEnemy)
//            projectileDidCollideWithMonster(projectile: projectile, monster: middleEnemy)
//            projectileDidCollideWithMonster(projectile: projectile, monster: bottomEnemy)
        }
        
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
        while middleInit < 10
        {
            addEnemyMiddle()
        }
        while middleInitB < 10
        {
            addEnemyMiddleB()
        }
        while bottomInit < 10
        {
            addEnemyBottom()
        }
        while bottomInitB < 10
        {
            addEnemyBottomB()
        }
        shootButtonA = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 150, height: 100))
        shootButtonA.name = "SBA"
        shootButtonA.position = CGPoint(x: -435, y: -235)
        shootButtonA.isUserInteractionEnabled = false
        self.addChild(shootButtonA)
        
        shootButtonB = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 150, height: 100))
        shootButtonB.name = "SBB"
        shootButtonB.position = CGPoint(x: 435, y: -235)
        shootButtonB.isUserInteractionEnabled = false
        self.addChild(shootButtonB)
        
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
        topEnemy.removeFromParent()
        middleEnemy.removeFromParent()
        bottomEnemy.removeFromParent()
    }
    func didBegin(_ contact: SKPhysicsContact) {
        print("In didBegin")
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        // If they can become SKSpriteNode's, call function “projectileDidCollideWithMonster”
        // and pass them in so that they get removed from the game, showing as a "hit"
        if let monster = firstBody.node as? SKSpriteNode, let
            projectile = secondBody.node as? SKSpriteNode {
            projectileDidCollideWithMonster(projectile: projectile, monster: monster)
        }
    }
    func random() -> CGFloat {
        return CGFloat(Float(arc4random())/0xFFFFFFFF)
    }
    
    func addEnemyTop() {


        
        let topFrames: [SKTexture] = [f0, f1]

        
        // Load the first frame as initialization
        let topEnemy = SKSpriteNode(imageNamed: "topEnemyPositionA")

        
        //Animate
        let topAnimation = SKAction.animate(with: topFrames, timePerFrame: 0.4)
        topEnemy.run(SKAction.repeatForever(topAnimation))
        
        // Physics body (Probably Broken)
        topEnemy.physicsBody = SKPhysicsBody(rectangleOf: topEnemy.size)
        topEnemy.physicsBody?.isDynamic = true
        topEnemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        topEnemy.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        topEnemy.physicsBody?.collisionBitMask = PhysicsCategory.None
        topEnemy.xScale = 1
        topEnemy.yScale = 1
        
        
        // Set position
        topEnemy.position = CGPoint(x: (-420 + (topInit * 98)) , y: 240)
        addChild(topEnemy)
        
        
        topInit += 1
        
    }
    func addEnemyMiddle() {

        
        let middleFrames: [SKTexture] = [f2, f3]
        
        // Load the first frame as initialization
        let middleEnemy = SKSpriteNode(imageNamed: "middleEnemyPositionA")
        
        //Animate
        let middleAnimation = SKAction.animate(with: middleFrames, timePerFrame: 0.4)
        middleEnemy.run(SKAction.repeatForever(middleAnimation))

        
        // Physics body (Probably Broken)
        middleEnemy.physicsBody = SKPhysicsBody(rectangleOf: middleEnemy.size)
        middleEnemy.physicsBody?.isDynamic = true
        middleEnemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        middleEnemy.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        middleEnemy.physicsBody?.collisionBitMask = PhysicsCategory.None
        middleEnemy.xScale = 1
        middleEnemy.yScale = 1
        
        
        // Set position
        middleEnemy.position = CGPoint(x: (-420 + (middleInit * 98)) , y: 160)
        addChild(middleEnemy)
        
        
        middleInit += 1
        
    }
    func addEnemyMiddleB() {

        let middleFrames: [SKTexture] = [f2, f3]
        
        // Load the first frame as initialization
        let middleEnemy = SKSpriteNode(imageNamed: "middleEnemyPositionA")
        
        //Animate
        let middleAnimation = SKAction.animate(with: middleFrames, timePerFrame: 0.4)
        middleEnemy.run(SKAction.repeatForever(middleAnimation))
        
        
        // Physics body (Probably Broken)
        middleEnemy.physicsBody = SKPhysicsBody(rectangleOf: middleEnemy.size)
        middleEnemy.physicsBody?.isDynamic = true
        middleEnemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        middleEnemy.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        middleEnemy.physicsBody?.collisionBitMask = PhysicsCategory.None
        middleEnemy.xScale = 1
        middleEnemy.yScale = 1
        
        
        // Set position
        middleEnemy.position = CGPoint(x: (-420 + (middleInitB * 98)) , y: 80)
        addChild(middleEnemy)
        
        
        middleInitB += 1
        
    }
    func addEnemyBottom() {

        
        let bottomFrames: [SKTexture] = [f4, f5]
        
        // Load the first frame as initialization
        let bottomEnemy = SKSpriteNode(imageNamed: "bottomEnemyPositionA")
        
        //Animate
        let bottomAnimation = SKAction.animate(with: bottomFrames, timePerFrame: 0.4)
        bottomEnemy.run(SKAction.repeatForever(bottomAnimation))
        
        
        // Physics body (Probably Broken)
        bottomEnemy.physicsBody = SKPhysicsBody(rectangleOf: bottomEnemy.size)
        bottomEnemy.physicsBody?.isDynamic = true
        bottomEnemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        bottomEnemy.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        bottomEnemy.physicsBody?.collisionBitMask = PhysicsCategory.None
        bottomEnemy.xScale = 1
        bottomEnemy.yScale = 1
        
        
        // Set position
        bottomEnemy.position = CGPoint(x: (-420 + (bottomInit * 98)) , y: 0)
        addChild(bottomEnemy)
        
        
        bottomInit += 1
        
    }
    func addEnemyBottomB() {

        
        let bottomFrames: [SKTexture] = [f4, f5]
        
        // Load the first frame as initialization
        let bottomEnemy = SKSpriteNode(imageNamed: "bottomEnemyPositionA")
        
        //Animate
        let bottomAnimation = SKAction.animate(with: bottomFrames, timePerFrame: 0.4)
        bottomEnemy.run(SKAction.repeatForever(bottomAnimation))
        
        
        // Physics body (Probably Broken)
        bottomEnemy.physicsBody = SKPhysicsBody(rectangleOf: bottomEnemy.size)
        bottomEnemy.physicsBody?.isDynamic = true
        bottomEnemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        bottomEnemy.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        bottomEnemy.physicsBody?.collisionBitMask = PhysicsCategory.None
        bottomEnemy.xScale = 1
        bottomEnemy.yScale = 1
        
        
        // Set position
        bottomEnemy.position = CGPoint(x: (-420 + (bottomInitB * 98)) , y: -80)
        addChild(bottomEnemy)
        
        
        bottomInitB += 1
        
    }
    
    
    
    
    
}








