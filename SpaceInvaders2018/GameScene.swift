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
    var topInit = 0
    override func didMove(to view: SKView)
    {
        while topInit < 11
        {
            addEnemyTop()
        }
    }

    func random() -> CGFloat {
        return CGFloat(Float(arc4random())/0xFFFFFFFF)
    }
    func addEnemyTop() {
        let f0 = SKTexture.init(imageNamed: "topEnemyPositionA.png")
        let f1 = SKTexture.init(imageNamed: "topEnemyPositionB.png")

        let frames: [SKTexture] = [f0, f1]
        
        // Load the first frame as initialization
        let enemy = SKSpriteNode(imageNamed: "topEnemyPositionA.png")
        
        // Change the frame per 0.2 sec
        let animation = SKAction.animate(with: frames, timePerFrame: 0.2)
        enemy.run(SKAction.repeatForever(animation))
        
        // Physics body (Probably Broken)
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // Set position
        enemy.position = CGPoint(x: (-384 - (topInit * 98)) , y: 180 )
        addChild(enemy)

        topInit += 1
        }

    }

