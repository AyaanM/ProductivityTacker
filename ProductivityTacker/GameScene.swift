//
//  GameScene.swift
//  ProductivityTacker
//
//  Created by Ayaan Merchant on 2023-07-01.
//

import UIKit
import SpriteKit

class GameScene: SKScene {
    
    //initialize classes
    var proTimer = Stopwatch()
    var breakTimer = Stopwatch()
    
    //define buttons
    var takeBreakLabel: SKLabelNode!
    var startLabel: SKLabelNode!
    var stopLabel: SKLabelNode!
    
    //define displays
    var breakTimeDisplay: SKLabelNode!
    var proTimeDisplay: SKLabelNode!
    var proTime = "00:00:00"
    var breakTime = "00:00"
        
    override func didMove(to view: SKView) {
        
        //create the productivity time display
        proTimeDisplay = SKLabelNode(fontNamed: "Hoefler Text")
        proTimeDisplay.name = "time"
        proTimeDisplay.fontSize = 40
        proTimeDisplay.text = proTime
        proTimeDisplay.position = CGPoint(x: self.size.width / 2, y: self.size.height - 125)
        addChild(proTimeDisplay)
        
        //create start button
        startLabel = SKLabelNode(fontNamed: "Hoefler Text")
        startLabel.fontSize = 45
        startLabel.text = "Start"
        startLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - 200)
        addChild(startLabel)
        
        //create stop button
        stopLabel = SKLabelNode(fontNamed: "Hoefler Text")
        stopLabel.fontSize = 45
        stopLabel.text = "Stop"
        stopLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - 200)
        stopLabel.isHidden = true //upon app launch hide stop label since timer not running
        addChild(stopLabel)
        
        //create take a break button
        takeBreakLabel = SKLabelNode(fontNamed: "Hoefler Text")
        takeBreakLabel.fontSize = 30
        takeBreakLabel.text = "Take a Break"
        takeBreakLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - 275)
        takeBreakLabel.isHidden = true
        addChild(takeBreakLabel)
        
        //create the breaktime display
        breakTimeDisplay = SKLabelNode(fontNamed: "Hoefler Text")
        breakTimeDisplay.name = "break"
        breakTimeDisplay.fontSize = 25
        breakTimeDisplay.text = breakTime
        breakTimeDisplay.position = CGPoint(x: self.size.width / 2, y: self.size.height - 325)
        breakTimeDisplay.isHidden = true
        addChild(breakTimeDisplay)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if let touch = touches.first {
                    let location = touch.location(in: self)
                    let objects = nodes(at: location)
                
                if objects.contains(proTimeDisplay) {
                    if !proTimer.timerCounting { //if the proTimer isn't already working
                        pickTime()
                    }
                }
            
                if objects.contains(startLabel) {
                    
                    proTimer.startTimer()
                    
                    startLabel.isHidden = true
                    stopLabel.isHidden = false
                    
                    breakTimer.resetTimer() //stop timer for break
                    
                }
                
                if objects.contains(stopLabel) {
                    proTimer.stopTimer()
                    
                    stopLabel.isHidden = true
                    startLabel.isHidden = false
                    
                    breakTimer.resetTimer()
                }
                
                if objects.contains(takeBreakLabel) {
                    proTimer.stopTimer() //pause the protimer and start break timer
                    
                    startLabel.isHidden = true
                    stopLabel.isHidden = false
                    
                    breakTimer.startTimer()
                }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
            super.update(currentTime)
        
            // Update the time label on every frame
            proTimeDisplay.text = proTimer.timeString
            breakTimeDisplay.text = breakTimer.timeString
        }
    
    func pickTime() {
        
        guard let viewController = self.view?.window?.rootViewController else {
                return
            }
        
        let ac = UIAlertController(title: "Pick Time", message: "Pick the time you would like to focus for, a notification will be sent once you have surpassed the time. If you pick 'I will decide', no notification will be sent and you can continue uninterrupted focus!", preferredStyle: .alert)
        
        let times = ["10 minutes", "25 minutes", "1 hour", "2 hours", "3 hours", "I will decide"]
        
        for time in times {
            ac.addAction(UIAlertAction(title: time, style: .default))
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        viewController.present(ac, animated: true)
        
    }
    
}
