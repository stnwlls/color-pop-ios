//
//  GameViewController.swift
//  Color Pop
//
//  Created by Austin Wells on 11/3/25.
//

import UIKit
import SpriteKit
import GameplayKit
import os.log

var sizeOfView: CGSize!
var notWhiteColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
var notBlackColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content including entities and graphs.
        
        sizeOfView = view!.frame.size
        gameAchievements()
        
        // Load 'TitleScene'
        if let view = self.view as! SKView? {
            if let scene = TitleScene(fileNamed: "TitleScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // For now there should only be one score saved, but it could be modified for multiple players
                highScore = scores[0].score
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Private Functions
    private func gameAchievements() {
        // Load any saved score, otherwise load sample score
        if let savedScores = loadScores() {
            scores += savedScores
        } else {
            // Load the sample data
            loadSampleScores()
        }
    }
    
    private func loadSampleScores() {
        guard let saved1 = SavedGame(name: "Color Pop", score: 0) else {
            fatalError("Unable to instantiate saved1")
        }
        scores += [saved1]
    }
    
// Old deprecated method (kept for reference):
//    private func loadScores() -> [SavedGame]? {
//        return NSKeyedUnarchiver.unarchiveObject(withFile: SavedGame.ArchiveURL.path) as? [SavedGame]
//    }

// New method using NSSecureCoding:
    private func loadScores() -> [SavedGame]? {
        do {
            let data = try Data(contentsOf: SavedGame.ArchiveURL)
            let scores = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, SavedGame.self], from: data) as? [SavedGame]
            return scores
        } catch {
            return nil
        }
    }
}
