//
//  GameScene.swift
//  Fly Til You Die
//
//  Created by Marist User on 3/9/18.
//  Copyright © 2018 Caferra and Coterwas. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var isGameStarted = Bool(false)
    var isInSettings = Bool(false)
    var isDied = Bool(false)
    let coinSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)
    
    var score = Int(0)
    var money = Int(0)
    var scoreLbl = SKLabelNode()
    var moneyLbl = SKLabelNode()
    var highscoreLbl = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    var names = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var settingsBtn = SKSpriteNode()
    var settings = SKSpriteNode()
    var closeSettingsBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    
    //Setup for nodes and scrolling assets for background
    var skyNode = SKSpriteNode()
    var skyNodeNext = SKSpriteNode()
    
    var cityNode = SKSpriteNode()
    var cityNextNode = SKSpriteNode()
    
    var lightsNode = SKSpriteNode()
    var lightsNodeNext = SKSpriteNode()
    
    var starsNode = SKSpriteNode()
    var starsNodeNext = SKSpriteNode()
    
    //CREATE THE BIRD ATLAS FOR ANIMATION
    let birdAtlas = SKTextureAtlas(named:"player")
    var birdSprites = Array<SKTexture>()
    var bird = SKSpriteNode()
    var repeatActionBird = SKAction()
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let location = touch.location(in: self)
//            //game has not started and player touches settings button
//            if settingsBtn.contains(location) && isGameStarted == false {
//                //remove settings button
//                settingsBtn.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
//                    self.settingsBtn.removeFromParent()
//                })
//                //create settings screen and close button
//                createSettings()
//                createCloseSettingsBtn()
//                isInSettings = true
//            }
//            //if the close button is touched, remove the button and settings
//            if closeSettingsBtn.contains(location) {
//                self.removeFromParent()
//                settings.removeFromParent()
//                isInSettings = false
//            }
            //If you touch the screen you start the game
            if isGameStarted == false && isInSettings == false {
                //1
                isGameStarted =  true
                bird.physicsBody?.affectedByGravity = true
                createPauseBtn()
                //2
                logoImg.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                    self.logoImg.removeFromParent()
                })
                settingsBtn.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                    self.settingsBtn.removeFromParent()
                })
                taptoplayLbl.removeFromParent()
                names.removeFromParent()
                //3
                self.bird.run(repeatActionBird)
                
                //1
                let spawn = SKAction.run({
                    () in
                    self.wallPair = self.createWalls()
                    self.addChild(self.wallPair)
                })
                //2
                let delay = SKAction.wait(forDuration: 1.5)
                let SpawnDelay = SKAction.sequence([spawn, delay])
                let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
                self.run(spawnDelayForever)
                //3
                let distance = CGFloat(self.frame.width + wallPair.frame.width)
                let movePillars = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
                let removePillars = SKAction.removeFromParent()
                moveAndRemove = SKAction.sequence([movePillars, removePillars])
                
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            } else {
                //4
                if isDied == false {
                    bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
                }
            }
        //}
        
        
        for touch in touches{
            let location = touch.location(in: self)
            //1
            if isDied == true{
                if restartBtn.contains(location){
                    if UserDefaults.standard.object(forKey: "highestScore") != nil {
                        let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                        if hscore < Int(scoreLbl.text!)!{
                            UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                        }
                    } else {
                        UserDefaults.standard.set(0, forKey: "highestScore")
                    }
                    restartScene()
                }
            } else {
                //2
                if pauseBtn.contains(location){
                    if self.isPaused == false{
                        self.isPaused = true
                        pauseBtn.texture = SKTexture(imageNamed: "play")
                    } else {
                        self.isPaused = false
                        pauseBtn.texture = SKTexture(imageNamed: "pause")
                    }
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if isGameStarted == true{
            if isDied == false{
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    let bg = node as! SKSpriteNode
                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x:bg.position.x + bg.size.width * 2, y:bg.position.y)
                    }
                }))
            }
        }
    }
    
    func createScene(){
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red:80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        for i in 0..<2
        {
            let background = SKSpriteNode(imageNamed: "bgNight")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
        //SET UP THE BIRD SPRITES FOR ANIMATION
        birdSprites.append(birdAtlas.textureNamed("bird1"))
        birdSprites.append(birdAtlas.textureNamed("bird2"))
        birdSprites.append(birdAtlas.textureNamed("bird3"))
        birdSprites.append(birdAtlas.textureNamed("bird4"))
        
        self.bird = createBird()
        self.addChild(bird)
        
        //PREPARE TO ANIMATE THE BIRD AND REPEAT THE ANIMATION FOREVER
        let animateBird = SKAction.animate(with: self.birdSprites, timePerFrame: 0.1)
        self.repeatActionBird = SKAction.repeatForever(animateBird)
        
        scoreLbl = createScoreLabel()
        self.addChild(scoreLbl)
        
        highscoreLbl = createHighscoreLabel()
        self.addChild(highscoreLbl)
        
        moneyLbl = createMoneyLabel()
        self.addChild(moneyLbl)
        
        createSettingsBtn()
        
        createLogo()
        
        names = createNames()
        self.addChild(names)
        
        taptoplayLbl = createTaptoplayLabel()
        self.addChild(taptoplayLbl)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.pillarCategory || firstBody.categoryBitMask == CollisionBitMask.pillarCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory || firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory || firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory{
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if isDied == false{
                isDied = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                self.bird.removeAllActions()
            }
        } else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.coinCategory {
            run(coinSound)
            score += 1
            money += 1
            scoreLbl.text = "\(score)"
            moneyLbl.text = "Coins: \(money)"
            secondBody.node?.removeFromParent()
        } else if firstBody.categoryBitMask == CollisionBitMask.coinCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            run(coinSound)
            score += 1
            money += 1
            scoreLbl.text = "\(score)"
            moneyLbl.text = "Coins: \(money)"
            firstBody.node?.removeFromParent()
        }
    }
    
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        isDied = false
        isGameStarted = false
        isInSettings = false
        score = 0
        createScene()
    }
}
