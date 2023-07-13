//
//  GameViewController.swift
//  ProductivityTacker
//
//  Created by Ayaan Merchant on 2023-07-01.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var currentGame: GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene //assign optionally to current game
                currentGame?.viewController = self //set viewController as self to establish communication
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
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
        return false
    }
    
    func checkTimesUp() {
        
        if currentGame!.focus.timerCounting == true {
            if currentGame!.focus.elapsedTime == currentGame!.focusRemaining {
                currentGame!.focus.stopTimer() //stop focus timer
                currentGame!.focus.elapsedTime = 0
                currentGame!.focusStartStopButton.text = "Start"
                
                let ac = UIAlertController(title: "Focus time up!", message: "You can head on you break now, you can choose to continue focus, and no more alerts will be sent", preferredStyle: .alert)
                
                ac.addAction(UIAlertAction(title: "Take Break", style: .default, handler: { _ in
                    self.currentGame!.startBreak()
                }))
                ac.addAction(UIAlertAction(title: "Continue", style: .default))
                
                present(ac, animated: true)
            }
        }
        
        if currentGame!.rest.timerCounting == true {
            if currentGame!.rest.elapsedTime == currentGame!.restRemaining {
                currentGame!.rest.stopTimer()
                currentGame!.restStartStopButton.text = "Start"
                currentGame!.rest.elapsedTime = 0
                
                let ac = UIAlertController(title: "Break time up!", message: "You must now focus again!", preferredStyle: .alert)
                
                ac.addAction(UIAlertAction(title: "Focus Mode", style: .default, handler: { _ in
                    self.currentGame!.startFocus()
                }))
                
                present(ac, animated: true)
            }
        }
    }
    
    func pickTime(timerName: String) {
        
        // Take in what type of timer to set and pick at what time the timer should be set
        var messages: String
        var times: [(String, Int)] //the time in string format:the seconds in int format

        // define action for different timer types
        if timerName == "focus" { //if the focus timer is toggled
            messages = "Pick the time you would like to focus for, 'run timer already' means no set time (uniterrupted focus)"
            times = [("10 minutes", 600), ("25 minutes", 1500), ("45 minutes", 2700), ("1 hour", 3600), ("2 hours", 7200), ("3 hours", 10800)]
        } else {
            messages = "Pick the time you would like to take a break for, a notification will be sent when the break ends. If you exceed your break by 5 minutes your phone will explode."
            times = [("5 minutes", 300), ("10 minutes", 600), ("15 minutes", 900), ("30 minutes", 1800)]
        }

        // create the alert
        let ac = UIAlertController(title: "Pick Time", message: messages, preferredStyle: .actionSheet)

        // depending on what was picked, change variables
        for time in times { //time string and time int]
            let (tString, tInt) = time
            ac.addAction(UIAlertAction(title: tString, style: .default) {
                [self] _ in
                if timerName == "focus" {
                    currentGame!.focusRemaining = tInt
                    currentGame!.focus.remainingTime = tInt
                    currentGame!.focus.remainingTimeString = currentGame!.focus.getTimeString(seconds: tInt)
                } else {
                    currentGame!.restRemaining = tInt
                    currentGame!.rest.remainingTime = tInt
                    currentGame!.rest.remainingTimeString = currentGame!.rest.getTimeString(seconds: tInt)
                }
            })
        }

        present(ac, animated: true)
        
    }
}
