//
//  GameScene.swift
//  Color Pop
//
//  Created by Austin Wells on 11/3/25.
//

import SpriteKit
import GameplayKit
import os.log

var balloon0: SKSpriteNode?     // Orange
var balloon1: SKSpriteNode?     // Green
var balloon2: SKSpriteNode?     // Blue
var balloon3: SKSpriteNode?     // Purple

var balloonSize = CGSize(width: sizeOfView.width/3, height: sizeOfView.width/3)     // Keep it a square
var balloonPositionOffset = balloonSize.height / 2.0 + 20.0

var correctPosition: CGPoint?

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var statusLabel: SKLabelNode?
    var scoreLabel: SKLabelNode?
    var timerLabel: SKLabelNode?
    
    var score = 0
    var isAlive = true
    
    var countDownTimerVar = 0
    
    // orange
    var color0 = UIColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1.0)
    
    // green
    var color1 = UIColor(red: 79/255, green: 143/255, blue: 0/255, alpha: 1.0)
    
    // blue
    var color2 = UIColor(red: 0/255, green: 135/255, blue: 244/255, alpha: 1.0)
    
    // purple
    var color3 = UIColor(red: 160/255, green: 0/255, blue: 255/255, alpha: 1.0)
    
    var upperLeft = CGPoint()
    var upperRight = CGPoint()
    var lowerLeft = CGPoint()
    var lowerRight = CGPoint()
    var positionChoices = [CGPoint]()
    
    var colorAttributes = [UIColor]()
    var colorNames = ["Orange", "Green", "Blue", "Purple"]
    
    var colorNameIndex = 0
    var colorNameChosen = "White"
    var colorAttributeIndex = 0
    var balloonPosition = 0
    
    var touchLocation: CGPoint?
    var touchedNode: SKNode?
    
    override func didMove(to view: SKView) {
        self.backgroundColor = notBlackColor
        
        resetGameVariables()
        spawnStatusLabel()
        spawnScoreLabel()
        spawnTimerLabel()
        countDownTimer()
        randomizeColors()
    }
    
    func resetGameVariables() {
        score = 0
        isAlive = true
        
        countDownTimerVar = COUNTDOWN
        positionChoices = [upperLeft, upperRight, lowerLeft, lowerRight]
        colorAttributes = [color0, color1, color2, color3]
        
        spawnBalloon0()
        spawnBalloon1()
        spawnBalloon2()
        spawnBalloon3()
        loadPositionArray()
    }
    
    func spawnBalloon0() {
        // balloon0 = orange
        balloon0 = SKSpriteNode(imageNamed: "orangeBalloon")
        balloon0?.size = balloonSize
        balloon0?.position = CGPoint(x: self.frame.midX - balloonPositionOffset, y: self.frame.midY + balloonPositionOffset)
        self.addChild(balloon0!)
    }
    
    func spawnBalloon1() {
        // balloon1 = green
        balloon1 = SKSpriteNode(imageNamed: "greenBalloon")
        balloon1?.size = balloonSize
        balloon1?.position = CGPoint(x: self.frame.midX + balloonPositionOffset, y: self.frame.midY + balloonPositionOffset)
        self.addChild(balloon1!)
    }
    
    func spawnBalloon2() {
        // balloon2 = blue
        balloon2 = SKSpriteNode(imageNamed: "blueBalloon")
        balloon2?.size = balloonSize
        balloon2?.position = CGPoint(x: self.frame.midX + balloonPositionOffset, y: self.frame.midY - balloonPositionOffset)
        self.addChild(balloon2!)
    }
    
    func spawnBalloon3() {
        // balloon3 = purple
        balloon3 = SKSpriteNode(imageNamed: "purpleBalloon")
        balloon3?.size = balloonSize
        balloon3?.position = CGPoint(x: self.frame.midX - balloonPositionOffset, y: self.frame.midY - balloonPositionOffset)
        self.addChild(balloon3!)
    }
    
    func spawnStatusLabel() {
        statusLabel = SKLabelNode(fontNamed: "Marker Felt")
        statusLabel?.fontColor = notWhiteColor
        statusLabel?.fontSize = 100
        statusLabel?.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 300.0)
        
        statusLabel?.text = "Start!"
        self.addChild(statusLabel!)
    }
    
    func spawnScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Marker Felt")
        scoreLabel?.fontColor = notWhiteColor
        scoreLabel?.fontSize = 40
        scoreLabel?.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 185.0)
        
        scoreLabel?.text = "Score: \(score)"
        self.addChild(scoreLabel!)
    }
    
    func spawnTimerLabel() {
        timerLabel = SKLabelNode(fontNamed: "Marker Felt")
        timerLabel?.fontColor = notWhiteColor
        timerLabel?.fontSize = 70
        timerLabel?.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 255.0)
        
        timerLabel?.text = "\(COUNTDOWN)"
        self.addChild(timerLabel!)
    }
    
    func spawnBonusFireworks() {
        var explosion: SKEmitterNode?
        
        explosion = SKEmitterNode(fileNamed: "SparkParticle.sks")!
        
        explosion?.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        explosion?.zPosition = -1
        explosion?.targetNode = self
        
        self.addChild(explosion!)
        
        let explosionTimerRemove = SKAction.wait(forDuration: 1.0)
        
        let removeExplosion = SKAction.run {
            explosion?.removeFromParent()
            self.resetTheGame()
        }
        
        self.run(SKAction.sequence([explosionTimerRemove, removeExplosion]))
    }
    
    func loadPositionArray() {
        positionChoices[0] = CGPoint(x: self.frame.midX - balloonPositionOffset, y: self.frame.midY + balloonPositionOffset)
        positionChoices[1] = CGPoint(x: self.frame.midX + balloonPositionOffset, y: self.frame.midY + balloonPositionOffset)
        positionChoices[2] = CGPoint(x: self.frame.midX - balloonPositionOffset, y: self.frame.midY - balloonPositionOffset)
        positionChoices[3] = CGPoint(x: self.frame.midX + balloonPositionOffset, y: self.frame.midY - balloonPositionOffset)
    }
    
    func randomizeColors() {
        // Random name
        colorNameIndex = Int(arc4random_uniform(4))
        
        // Random color attribute for name
        colorAttributeIndex = Int(arc4random_uniform(4))
        balloonPosition = Int(arc4random_uniform(4))
        
        printColor()
        displayBalloons()
    }
    
    func printColor() {
        statusLabel?.text = "\(colorNames[colorNameIndex])"
        statusLabel?.fontColor = colorAttributes[colorAttributeIndex]
    }
    
    func displayBalloons() {
        // Reset all balloon names to "wrongBalloon" first
        balloon0?.name = "wrongBalloon"
        balloon1?.name = "wrongBalloon"
        balloon2?.name = "wrongBalloon"
        balloon3?.name = "wrongBalloon"
        
        // Based on the color name, set the correct balloon to the name rightBalloon and the random position
        switch colorNameIndex {
        case 0:
            balloon0?.name = "rightBalloon"
            balloon0?.position = positionChoices[balloonPosition]
            positionBalloons123(balloon0Position: balloonPosition)
        case 1:
            balloon1?.name = "rightBalloon"
            balloon1?.position = positionChoices[balloonPosition]
            positionBalloons023(balloon1Position: balloonPosition)
        case 2:
            balloon2?.name = "rightBalloon"
            balloon2?.position = positionChoices[balloonPosition]
            positionBalloons013(balloon2Position: balloonPosition)
        case 3:
            balloon3?.name = "rightBalloon"
            balloon3?.position = positionChoices[balloonPosition]
            positionBalloons012(balloon3Position: balloonPosition)
        default:
            balloon0?.name = "rightBalloon"
        }
    }
    
    // MARK: Positions for each of the remaining 3 balloons based on the selected balloon's position
    // We have the balloon 0 position, randomize the rest
    func positionBalloons123(balloon0Position: Int) {
        // Randomly get positions for balloons 1, 2, and 3
        var position1 = balloon0Position
        // Be sure to get a different position1
        while position1 == balloon0Position {
            position1 = Int(arc4random_uniform(4))
        }
        
        var position2 = position1
        // Be sure to get a different position2
        while position2 == balloon0Position || position2 == position1 {
            position2 = Int(arc4random_uniform(4))
        }
        
        var position3 = position2
        // Be sure to get a different position3
        while position3 == balloon0Position || position3 == position1 || position3 == position2 {
            position3 = Int(arc4random_uniform(4))
        }
        
        balloon1?.position = positionChoices[position1]
        balloon2?.position = positionChoices[position2]
        balloon3?.position = positionChoices[position3]
    }
    
    func positionBalloons023(balloon1Position: Int) {
        // Randomly get positions for balloons 0, 2, and 3
        var position0 = balloon1Position
        // Be sure to get a different position0
        while position0 == balloon1Position {
            position0 = Int(arc4random_uniform(4))
        }
        
        var position2 = position0
        // Be sure to get a different position2
        while position2 == balloon1Position || position2 == position0 {
            position2 = Int(arc4random_uniform(4))
        }
        
        var position3 = position2
        // Be sure to get a different position3
        while position3 == balloon1Position || position3 == position0 || position3 == position2 {
            position3 = Int(arc4random_uniform(4))
        }
        
        balloon0?.position = positionChoices[position0]
        balloon2?.position = positionChoices[position2]
        balloon3?.position = positionChoices[position3]
    }
    
    func positionBalloons013(balloon2Position: Int) {
        // Randomly get positions for balloons 0, 1, and 3
        var position0 = balloon2Position
        // Be sure to get a different position0
        while position0 == balloon2Position {
            position0 = Int(arc4random_uniform(4))
        }
        
        var position1 = position0
        // Be sure to get a different position1
        while position1 == balloon2Position || position1 == position0 {
            position1 = Int(arc4random_uniform(4))
        }
        
        var position3 = position1
        // Be sure to get a different position3
        while position3 == balloon2Position || position3 == position0 || position3 == position1 {
            position3 = Int(arc4random_uniform(4))
        }
        
        balloon0?.position = positionChoices[position0]
        balloon1?.position = positionChoices[position1]
        balloon3?.position = positionChoices[position3]
    }
    
    func positionBalloons012(balloon3Position: Int) {
        // Randomly get positions for balloons 0, 1, 2
        var position0 = balloon3Position
        // Be sure to get a different position0
        while position0 == balloon3Position {
            position0 = Int(arc4random_uniform(4))
        }
        
        var position1 = position0
        // Be sure to get a different position1
        while position1 == balloon3Position || position1 == position0 {
            position1 = Int(arc4random_uniform(4))
        }
        
        var position2 = position1
        // Be sure to get a different position2
        while position2 == balloon3Position || position2 == position0 || position2 == position1 {
            position2 = Int(arc4random_uniform(4))
        }
        
        balloon0?.position = positionChoices[position0]
        balloon1?.position = positionChoices[position1]
        balloon2?.position = positionChoices[position2]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchLocation = touch.location(in: self)
            touchedNode = atPoint(touchLocation!)
            
            if touchedNode?.name != "rightBalloon" {
                isAlive = false
                gameOverLogic()
            }
            
            // If it is the right balloon, color coded fireworks then wait and reSpawn
            if touchedNode?.name == "rightBalloon" {
                self.addToScore()
                self.randomizeColors()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func addToScore() {
        score = score + 1
        updateScore()
    }
    
    func updateScore() {
        scoreLabel?.text = "Score: \(score)"
    }
    
    func countDownTimer() {
        let wait = SKAction.wait(forDuration: 1.0)
        let runCountDown = SKAction.run {
            if self.isAlive == true {
                self.countDownTimerVar = self.countDownTimerVar - 1
            }
            
            if self.countDownTimerVar <= COUNTDOWN && self.isAlive == true {
                self.timerLabel?.text = "\(self.countDownTimerVar)"
            }
            
            if self.countDownTimerVar <= 0 {
                self.timerLabel?.text = "0"
                self.gameOverLogic()
            }
        }
        
        let sequence = SKAction.sequence([wait, runCountDown])
        self.run(SKAction.repeat(sequence, count: countDownTimerVar))
    }
    
    func gameOverLogic() {
        statusLabel?.fontColor = notWhiteColor
        statusLabel?.text = "Good Score!"
        timerLabel?.text = "Try Again"
        
        if isAlive == false {
            statusLabel?.text = "Game Reset"
            COUNTDOWN = 10
            if score == 0 {
                statusLabel?.fontColor = UIColor.red
                statusLabel?.text = "Skunked!"
                timerLabel?.text = "Game Over!"
                self.waitThenMoveToTitleScreen()
            }
        }
        
        balloon0?.removeFromParent()
        balloon1?.removeFromParent()
        balloon2?.removeFromParent()
        balloon3?.removeFromParent()
        
        // For now, there is only one high score and you can just replace the score
        if score > highScore {
            highScore = score
            statusLabel?.fontColor = UIColor.yellow
            statusLabel?.text = "High Score! \(highScore)"
            saveScores()
        } else if isAlive == true {
            statusLabel?.text = "Awesome!"
        }
        
        // Good scores increase the timer (better than half the countdown)
        if (isAlive == true && score > COUNTDOWN/2) {
            COUNTDOWN = COUNTDOWN + 5
            timerLabel?.text = "Timer increased!"
            spawnBonusFireworks()
        } else {
            self.resetTheGame()
        }
    }
    
    func resetTheGame() {
        let wait = SKAction.wait(forDuration: 2.0)
        let gameScene = GameScene(size: self.size)
        let transitionScene = SKTransition.doorway(withDuration: 0.5)
        
        let changeScene = SKAction.run {
            self.removeAllActions() // SKUNK FIX
            gameScene.scaleMode = SKSceneScaleMode.aspectFill
            self.scene?.view?.presentScene(gameScene, transition: transitionScene)
        }
        
        let sequence = SKAction.sequence([wait, changeScene])
        self.run(SKAction.repeat(sequence, count: 1))
    }
    
    @objc func waitThenMoveToTitleScreen() {
        let wait = SKAction.wait(forDuration: 1.0)
        let transition = SKAction.run {
            if let scene = TitleScene(fileNamed: "TitleScene") {
                let skView = self.view! as SKView
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                skView.presentScene(scene)
            }
        }
        
        let sequence = SKAction.sequence([wait, transition])
        self.run(SKAction.repeat(sequence, count: 1))
    }
    
    // MARK: Private Functions
    
// Old deprecated method (kept for reference):
//  private func saveScores() {
//      scores[0].score = highScore
//      let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(scores, toFile: SavedGame.ArchiveURL.path)
//
//      if isSuccessfulSave {
//          os_log("High Score successfully saved.", log: OSLog.default, type: .debug)
//      } else {
//          os_log("Failed to save high score...", log: OSLog.default, type: .error)
//      }
//  }
    
// New method using NSSecureCoding:
    private func saveScores() {
        scores[0].score = highScore
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: scores, requiringSecureCoding: false)
            try data.write(to: SavedGame.ArchiveURL)
            os_log("High Score successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save high score...", log: OSLog.default, type: .error)
        }
    }
}

