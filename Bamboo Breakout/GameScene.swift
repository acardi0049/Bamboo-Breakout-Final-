//
//  GameScene.swift
//  BREAKOUT
//
//  Created by acardi0049 on 5/2/18.
//  Copyright © 2018 acardi0049. All rights reserved.
//

import SpriteKit

let BallCategoryName = "ball"
let PaddleCategoryName = "paddle"
let BlockCategoryName = "block"
let GameMessageName = "gameMessage"

let BallCategory   : UInt32 = 0x1 << 0
let BottomCategory : UInt32 = 0x1 << 1
let BlockCategory  : UInt32 = 0x1 << 2
let PaddleCategory : UInt32 = 0x1 << 3
let BorderCategory : UInt32 = 0x1 << 4

class GameScene: SKScene, SKPhysicsContactDelegate {
  
  var isFingerOnPaddle = false
  
 
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    
// 1
    let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
// 2
    borderBody.friction = 0
// 3
    self.physicsBody = borderBody
    
    physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
    physicsWorld.contactDelegate = self
    
    let ball = childNode(withName: BallCategoryName) as! SKSpriteNode
    ball.physicsBody!.applyImpulse(CGVector(dx: 2.0, dy: -2.0))
    
    let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1)
    let bottom = SKNode()
    bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
    addChild(bottom)
    
    let paddle = childNode(withName: PaddleCategoryName) as! SKSpriteNode
    
    bottom.physicsBody!.categoryBitMask = BottomCategory
    ball.physicsBody!.categoryBitMask = BallCategory
    paddle.physicsBody!.categoryBitMask = PaddleCategory
    borderBody.categoryBitMask = BorderCategory
    
    ball.physicsBody!.contactTestBitMask = BottomCategory
    
  }
  
  // MARK: Events
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first
    let touchLocation = touch!.location(in: self)
    
    if let body = physicsWorld.body(at: touchLocation) {
      if body.node!.name == PaddleCategoryName {
        print("Began touch on paddle")
        isFingerOnPaddle = true
      }
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    // 1.
    if isFingerOnPaddle {
      // 2.
      let touch = touches.first
      let touchLocation = touch!.location(in: self)
      let previousLocation = touch!.previousLocation(in: self)
      // 3.
      let paddle = childNode(withName: PaddleCategoryName) as! SKSpriteNode
      // 4.
      var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
      // 5.
      paddleX = max(paddleX, paddle.size.width/2)
      paddleX = min(paddleX, size.width - paddle.size.width/2)
      // 6.
      paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    isFingerOnPaddle = false
  }
  
  
  func didBegin(_ contact: SKPhysicsContact) {
    // 1.
    var firstBody: SKPhysicsBody
    var secondBody: SKPhysicsBody
    // 2.
    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
      firstBody = contact.bodyA
      secondBody = contact.bodyB
    } else {
      firstBody = contact.bodyB
      secondBody = contact.bodyA
    }
    // 3.
    if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
      print("Hit bottom. First contact has been made.")
    }
  }
}
