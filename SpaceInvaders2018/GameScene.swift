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
    let player = SKSpriteNode(imageNamed: "player")
    var button: SKNode! = nil
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        print("onscreen")
        player.position.x += 10
        if button.contains(touch.location(in: self)) {
            print("touched")
            player.position.x += 10
        }
    }
    
    override func didMove(to view: SKView)
    {
        while topInit < 10
        {
            addEnemyTop()
            
        }
      
            button = SKSpriteNode(color: SKColor.green, size: CGSize(width: 150, height: 100))
            button.position = CGPoint(x: 435, y: -335);
            button.isUserInteractionEnabled = true
        
        
            self.addChild(button)
        
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

