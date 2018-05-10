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
    
    // create player as generic spriteNode variable
    var player = SKSpriteNode()
    var rightButton = SKSpriteNode()
    var leftButton = SKSpriteNode()
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if var name = touchedNode.name
        {
            if name == "RButton"
            {
                print("Touched at \(touch.location(in: self))")
                player.position.x += 16


            } else if name == "LButton" {
                print("Touched at \(touch.location(in: self))")
                player.position.x -= 16
            }
        }
        
        print("onscreen")
    }
    
    override func didMove(to view: SKView)
    {
   
        physicsWorld.contactDelegate = self
    
        player = self.childNode(withName: "player") as! SKSpriteNode

        while topInit < 10
        {
            addEnemyTop()
            
        }
        
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
