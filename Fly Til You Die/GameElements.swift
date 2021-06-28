//
//  GameElements.swift
//  Fly Til You Die
//
//  Created by Marist User on 3/9/18.
//  Copyright © 2018 Caferra and Coterwas. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    static let birdCategory:UInt32 = 0x1 << 0
    static let pillarCategory:UInt32 = 0x1 << 1
    static let coinCategory:UInt32 = 0x1 << 2
    static let groundCategory:UInt32 = 0x1 << 3
}

extension GameScene {
    func createBird() -> SKSpriteNode {
        //1
        let bird = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("bird1"))
        bird.size = CGSize(width: 50, height: 50)
        bird.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        //2
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
        bird.physicsBody?.linearDamping = 1.1
        bird.physicsBody?.restitution = 0
        //3
        bird.physicsBody?.categoryBitMask = CollisionBitMask.birdCategory
        bird.physicsBody?.collisionBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
        bird.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.coinCategory | CollisionBitMask.groundCategory
        //4
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        
        return bird
    }
    //1
    func createRestartBtn() {
        restartBtn = SKSpriteNode(imageNamed: "restart")
        restartBtn.size = CGSize(width:100, height:100)
        restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func createSettings() {
        settings = SKSpriteNode(imageNamed: "bg")
        settings.name = "settings"
        //settings.centerRect = CGRect(x: self.frame.width / 2, y: self.frame.width / 2, width: 300, height: 500)
        settings.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        settings.color = .white
        settings.zPosition = 7
        self.addChild(settings)
    }
    func createSettingsBtn() {
        settingsBtn = SKSpriteNode(imageNamed: "settings")
        settingsBtn.size = CGSize(width:100, height:100)
        settingsBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 4)
        settingsBtn.zPosition = 6
        settingsBtn.setScale(0)
        self.addChild(settingsBtn)
        settingsBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    func createCloseSettingsBtn() {
        closeSettingsBtn = SKSpriteNode(imageNamed: "restart")
        closeSettingsBtn.size = CGSize(width:100, height:100)
        closeSettingsBtn.position = CGPoint(x: self.frame.width / 3, y: self.frame.height / 4)
        closeSettingsBtn.zPosition = 8
        closeSettingsBtn.setScale(0)
        self.addChild(closeSettingsBtn)
        closeSettingsBtn.run(SKAction.scale(to: 1.0, duration: 0.3))

    }
    func createNames() -> SKLabelNode {
        let names = SKLabelNode()
        names.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 50)
        names.text = "Made by: Erina Caferra and Kim Coterwas"
        names.fontColor = UIColor(red: 200/255, green: 79/255, blue: 145/255, alpha: 1.0)
        names.zPosition = 5
        names.fontSize = 12
        names.fontName = "HelveticaNeue"
        return names
    }
    //2
    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        pauseBtn.size = CGSize(width:40, height:40)
        pauseBtn.position = CGPoint(x: self.frame.width - 30, y: 30)
        pauseBtn.zPosition = 6
        self.addChild(pauseBtn)
    }
    //3
    func createScoreLabel() -> SKLabelNode {
        let scoreLbl = SKLabelNode()
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
        scoreLbl.text = "\(score)"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 50
        scoreLbl.fontName = "HelveticaNeue-Bold"
        
        let scoreBg = SKShapeNode()
        scoreBg.position = CGPoint(x: 0, y: 0)
        scoreBg.path = CGPath(roundedRect: CGRect(x: CGFloat(-50), y: CGFloat(-30), width: CGFloat(100), height: CGFloat(100)), cornerWidth: 50, cornerHeight: 50, transform: nil)
        let scoreBgColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(0.2))
        scoreBg.strokeColor = UIColor.clear
        scoreBg.fillColor = scoreBgColor
        scoreBg.zPosition = -1
        scoreLbl.addChild(scoreBg)
        return scoreLbl
    }
    //4
    func createHighscoreLabel() -> SKLabelNode {
        let highscoreLbl = SKLabelNode()
        highscoreLbl.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 22)
        if let highestScore = UserDefaults.standard.object(forKey: "highestScore"){
            highscoreLbl.text = "Highest Score: \(highestScore)"
        } else {
            highscoreLbl.text = "Highest Score: 0"
        }
        highscoreLbl.zPosition = 5
        highscoreLbl.fontSize = 15
        highscoreLbl.fontName = "Helvetica-Bold"
        return highscoreLbl
    }
    // money label
    func createMoneyLabel() -> SKLabelNode {
        let moneyLbl = SKLabelNode()
        moneyLbl.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 35)
        if let money = UserDefaults.standard.object(forKey: "money"){
            moneyLbl.text = "Coins: \(money)"
        } else {
            moneyLbl.text = "Coins: \(money)"
        }
        moneyLbl.zPosition = 5
        moneyLbl.fontSize = 15
        moneyLbl.fontName = "Helvetica-Bold"
        return moneyLbl
    }
    //5
    func createLogo() {
        logoImg = SKSpriteNode()
        logoImg = SKSpriteNode(imageNamed: "logo")
        logoImg.size = CGSize(width: 272, height: 65)
        logoImg.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 100)
        logoImg.setScale(0.5)
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    //6
    func createTaptoplayLabel() -> SKLabelNode {
        let taptoplayLbl = SKLabelNode()
        taptoplayLbl.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 100)
        taptoplayLbl.text = "Tap anywhere to play"
        taptoplayLbl.fontColor = UIColor(red: 200/255, green: 79/255, blue: 145/255, alpha: 1.0)
        taptoplayLbl.zPosition = 5
        taptoplayLbl.fontSize = 20
        taptoplayLbl.fontName = "HelveticaNeue"
        return taptoplayLbl
    }
    
    func createWalls() -> SKNode  {
        // 1
        let coinNode = SKSpriteNode(imageNamed: "coin")
        coinNode.size = CGSize(width: 40, height: 40)
        coinNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        coinNode.physicsBody = SKPhysicsBody(rectangleOf: coinNode.size)
        coinNode.physicsBody?.affectedByGravity = false
        coinNode.physicsBody?.isDynamic = false
        coinNode.physicsBody?.categoryBitMask = CollisionBitMask.coinCategory
        coinNode.physicsBody?.collisionBitMask = 0
        coinNode.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        coinNode.color = SKColor.blue
        // 2
        wallPair = SKNode()
        wallPair.name = "wallPair"
        
        let topWall = SKSpriteNode(imageNamed: "pillarNight")
        let btmWall = SKSpriteNode(imageNamed: "pillarNight")
        
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 420)
        btmWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 420)
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        topWall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        topWall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        btmWall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        btmWall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false
        
        topWall.zRotation = CGFloat(M_PI)
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        // 3
        let randomPosition = random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y +  randomPosition
        wallPair.addChild(coinNode)
        
        wallPair.run(moveAndRemove)
        
        return wallPair
    }
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
}


