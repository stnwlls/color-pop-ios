//
//  TitleScene.swift
//  Color Pop
//
//  Created by Austin Wells on 11/4/25.
//

import Foundation
import SpriteKit
import os.log

// Global COUNTDOWN, highScore, and scores array
var highScore: Int = 0
var scores = [SavedGame]()
var COUNTDOWN = 10

class TitleScene: SKScene {
    var btnPlay: UIButton!
    var btnReset: UIButton!
    var achievementTitle: UILabel!
    
    var gameTitle = SKLabelNode()
    var gameFAQs = SKLabelNode()
    var gameFAQ1 = SKLabelNode()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = notBlackColor
        
        setUpText()
    }
    
    @objc func playTheGame() {
        self.view?.presentScene(GameScene(), transition: SKTransition.fade(withDuration: 1.0))
        
        btnPlay.removeFromSuperview()
        btnReset.removeFromSuperview()
        achievementTitle.removeFromSuperview()
        
        gameTitle.removeFromParent()
        gameFAQs.removeFromParent()
        gameFAQ1.removeFromParent()
        
        if let scene = GameScene(fileNamed: "GameScene") {
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
    }

// Old deprecated method (kept for reference):
//    @objc func resetTheGame() {
//        achievementTitle.text = " "
//        scores[0].score = 0
//        highScore = 0
//        
//        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(scores, toFile: SavedGame.ArchiveURL.path)
//        
//        if isSuccessfulSave {
//            os_log("High Score successfully saved.", log: OSLog.default, type: .debug)
//        } else {
//            os_log("Failed to save high score...", log: OSLog.default, type: .error)
//        }
//    }

// New method using NSSecureCoding:
    @objc func resetTheGame() {
        achievementTitle.text = " "
        scores[0].score = 0
        highScore = 0
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: scores, requiringSecureCoding: false)
            try data.write(to: SavedGame.ArchiveURL)
            os_log("High Score successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save high score...", log: OSLog.default, type: .error)
        }
    }
    
    func setUpText() {
        // Be sure to scale the fonts and lable positions to fit the device view
        sizeOfView = view!.frame.size
        let scaleYPosition = sizeOfView.height
        let btnSize: CGFloat = view!.frame.size.width/3.8
        
        gameTitle = SKLabelNode(fontNamed: "Marker Felt")
        gameTitle.fontColor = notWhiteColor
        gameTitle.fontSize = scaleYPosition/13
        gameTitle.position = CGPoint(x: self.frame.midX, y: self.frame.midY + scaleYPosition/3.5)
        gameTitle.text = "COLOR POP!!!"
        
        self.addChild(gameTitle)
        
        gameFAQs = SKLabelNode(fontNamed: "Marker Felt")
        gameFAQs.fontColor = notWhiteColor
        gameFAQs.fontSize = scaleYPosition/50
        gameFAQs.position = CGPoint(x: self.frame.midX, y: self.frame.midY + scaleYPosition/4.2)
        gameFAQs.text = "--Pick the right color balloon based on the name of the color--"
        
        self.addChild(gameFAQs)
        
        gameFAQ1 = SKLabelNode(fontNamed: "Marker Felt")
        gameFAQ1.fontColor = notWhiteColor
        gameFAQ1.fontSize = scaleYPosition/50
        gameFAQ1.position = CGPoint(x: self.frame.midX, y: self.frame.midY + scaleYPosition/4.7)
        gameFAQ1.text = "--- NOT the color of the font for the displayed color name ---"
        
        self.addChild(gameFAQ1)
        
        spawnBalloon0()
        spawnBalloon1()
        spawnBalloon2()
        spawnBalloon3()
        
        // PLAY BUTTON with image
        btnPlay = UIButton(frame: CGRect(x: 0, y: 0, width: btnSize, height: btnSize))
        btnPlay.backgroundColor = notBlackColor
        // Left of center
        btnPlay.center = CGPoint(x: sizeOfView.width/2, y: (sizeOfView.height/2) + 50)
        btnPlay.setImage(UIImage(named: "playColorPopButton"), for: UIControl.State.normal)
        
        btnPlay.addTarget(self, action: (#selector(TitleScene.playTheGame)), for: UIControl.Event.touchUpInside)
        self.view?.addSubview(btnPlay)
        
        let margin: CGFloat = 20
        
        // HIGH SCORE
        achievementTitle = UILabel(frame: CGRect(x: margin, y: (scaleYPosition - 100), width: 500, height: 75))
        achievementTitle.textColor = notWhiteColor
        achievementTitle.font = UIFont(name: "Marker Felt", size: scaleYPosition/20)
        achievementTitle.textAlignment = NSTextAlignment.left
        
        if highScore != 0 {
            achievementTitle.text = "High Score: \(highScore)"
        }
        
        self.view?.addSubview(achievementTitle)
        
        // RESET HIGH SCORE
        btnReset = UIButton(frame: CGRect(x: 0, y: 0, width: btnSize/2.5, height: btnSize/2.5))
        btnReset.backgroundColor = notBlackColor
        // Bottom right corner
        btnReset.center = CGPoint(x: sizeOfView.width - (btnSize/5) - margin, y: sizeOfView.height - (btnSize/5) - margin)
        btnReset.setImage(UIImage(named: "resetColorPopButton"), for: UIControl.State.normal)
        
        btnReset.addTarget(self, action: (#selector(TitleScene.resetTheGame)), for: UIControl.Event.touchUpInside)
        self.view?.addSubview(btnReset)
    }
    
    // Spawn slightly smaller balloons with room for the play button.
    func spawnBalloon0() {
        balloon0 = SKSpriteNode(imageNamed: "orangeBalloon")
        balloon0?.size = CGSize(width: (balloonSize.width * 0.6), height: (balloonSize.height * 0.6))
        balloon0?.position = CGPoint(x: self.frame.midX - (balloonPositionOffset - 10), y: self.frame.midY + (balloonPositionOffset - 80))
        self.addChild(balloon0!)
    }
    
    func spawnBalloon1() {
        balloon1 = SKSpriteNode(imageNamed: "greenBalloon")
        balloon1?.size = CGSize(width: (balloonSize.width * 0.6), height: (balloonSize.height * 0.6))
        balloon1?.position = CGPoint(x: self.frame.midX + (balloonPositionOffset - 10), y: self.frame.midY + (balloonPositionOffset - 80))
        self.addChild(balloon1!)
    }
    
    func spawnBalloon2() {
        balloon2 = SKSpriteNode(imageNamed: "blueBalloon")
        balloon2?.size = CGSize(width: (balloonSize.width * 0.6), height: (balloonSize.height * 0.6))
        balloon2?.position = CGPoint(x: self.frame.midX - (balloonPositionOffset - 10), y: self.frame.midY - (balloonPositionOffset + 40))
        self.addChild(balloon2!)
    }
    
    func spawnBalloon3() {
        balloon3 = SKSpriteNode(imageNamed: "purpleBalloon")
        balloon3?.size = CGSize(width: (balloonSize.width * 0.6), height: (balloonSize.height * 0.6))
        balloon3?.position = CGPoint(x: self.frame.midX + (balloonPositionOffset - 10), y: self.frame.midY - (balloonPositionOffset + 40))
        self.addChild(balloon3!)
    }
}

