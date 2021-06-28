//
//  SplashScene.swift
//  Fly Til You Die
//
//  Created by Marist User on 3/9/18.
//  Copyright © 2018 Caferra and Coterwas. All rights reserved.
//

import SpriteKit

class SplashScene: SKScene {
    override func didMove(to view: SKView) {

            anchorPoint = CGPoint.zero

            let SplashBackground = SKSpriteNode(imageNamed: "bgNight")
            SplashBackground.anchorPoint = CGPoint.init(x: 0, y: 0)
            SplashBackground.size = (self.view?.bounds.size)!

            addChild(SplashBackground)

            let tapMethod = #selector(SplashScene.handleTap(tapGesture:))
            let tapGesture = UITapGestureRecognizer(target: self, action: tapMethod)
            view.addGestureRecognizer(tapGesture)

//            SplashBackground.removeFromParent()
    }
    
    @objc func handleTap(tapGesture: UITapGestureRecognizer) {
        goNext(scene: GameScene())
    }
    
    func goNext(scene: SKScene) {
        // view is an SKView? so we have to check
        if let view = self.view {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            // Adjust the size of the scene to match the view
            let width = view.bounds.width
            let height = view.bounds.height
            scene.size = CGSize(width: width, height: height)
            // let reveal = SKTransition.reveal(with: .down, duration: 5)
            let reveal = SKTransition.crossFade(withDuration: 5)
            view.presentScene(scene, transition: reveal)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

}
