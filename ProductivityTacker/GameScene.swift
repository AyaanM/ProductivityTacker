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
    var focusTimer = Stopwatch()
    var breakTimer = Stopwatch()
    
    //define buttons
    var takeBreakLabel: SKLabelNode!
    var startLabel: SKLabelNode!
    var stopLabel: SKLabelNode!
    
    //define displays
    var breakTimeDisplay: SKLabelNode!
    var focusTimeDisplay: SKLabelNode!
    var timeToFocusDisplay: SKLabelNode!
    var timeToBreakDisplay: SKLabelNode!
    
    //define variables
    var timeToFocus: Int = 0 //time chosen in seconds
    var timeToBreak: Int = 0
        
    override func didMove(to view: SKView) {
        
        //create the productivity time display
        focusTimeDisplay = SKLabelNode(fontNamed: "Hoefler Text")
        focusTimeDisplay.name = "time"
        focusTimeDisplay.fontSize = 40
        focusTimeDisplay.text = "00:00"
        focusTimeDisplay.position = CGPoint(x: self.size.width / 2, y: self.size.height - 125)
        addChild(focusTimeDisplay)
        
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
        addChild(takeBreakLabel)
        
        //create the breaktime display
        breakTimeDisplay = SKLabelNode(fontNamed: "Hoefler Text")
        breakTimeDisplay.name = "break"
        breakTimeDisplay.fontSize = 25
        breakTimeDisplay.text = "00:00"
        breakTimeDisplay.position = CGPoint(x: self.size.width / 2, y: self.size.height - 325)
        addChild(breakTimeDisplay)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if let touch = touches.first {
                    let location = touch.location(in: self)
                    let objects = nodes(at: location)
                
                if objects.contains(focusTimeDisplay) {
                    if !focusTimer.timerCounting { //if the proTimer isn't already working
                        pickTime(timerType: "focusTimer")
                    }
                }
                
                if objects.contains(breakTimeDisplay) {
                    if !breakTimer.timerCounting { //if the proTimer isn't already working
                        pickTime(timerType: "breakTimer")
                    }
                    print(timeToBreak)
                }
            
                if objects.contains(startLabel) {
                    
                    startLabel.isHidden = true
                    stopLabel.isHidden = false
                    
                    breakTimer.resetTimer() //stop timer for break
                    
                    focusTimer.startTimer()
                    
                }
                
                if objects.contains(stopLabel) {
                    focusTimer.stopTimer()
                    
                    stopLabel.isHidden = true
                    startLabel.isHidden = false
                    
                    breakTimer.resetTimer()
                }
                
                if objects.contains(takeBreakLabel) {
                    focusTimer.stopTimer() //pause the protimer and start break timer
                    
                    startLabel.isHidden = true
                    stopLabel.isHidden = false
                    
                    breakTimer.startTimer()
                }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    
        // Update the time label on every frame
        focusTimeDisplay.text = focusTimer.timeString
        breakTimeDisplay.text = breakTimer.timeString
        }
    
    func pickTime(timerType: String) {
        // Take in what type of timer to set and pick at what time the timer should be set
        var messages: String
        var times: [String: Int] = [:]
        
        guard let viewController = self.view?.window?.rootViewController else {
                return
            }
        
        // define action for different timer types
        if timerType == "focusTimer" { //if the focus timer is toggled
            messages = "Pick the time you would like to focus for, 'run timer already' means no set time (uniterrupted focus)"
            times = ["10 minutes": 600, "25 minutes": 1500, "1 hour": 3600, "2 hours": 7200, "3 hours": 10800, "I will decide": -1]
        } else {
            messages = "Pick the time you would like to take a break for, a notification will be sent when the break ends. If you exceed your break by 5 minutes your phone will explode."
            times = ["5 minutes": 300, "10 minutes": 600, "15 minutes": 900, "30 minutes": 1800]
        }
        
        // create the alert
        let ac = UIAlertController(title: "Pick Time", message: messages, preferredStyle: .actionSheet)
        
        // depending on what was picked, change variables
        for (tString, tInt) in times { //time string and time int
            ac.addAction(UIAlertAction(title: tString, style: .default) {
                [self] _ in
                if timerType == "focusTimer" {
                    self.timeToFocus = tInt
                    self.timeToFocusDisplay.text = self.focusTimer.getTimeString(seconds: tInt)
                } else {
                    self.timeToFocus = tInt
                    self.timeToBreakDisplay.text = self.breakTimer.getTimeString(seconds: tInt)
                }
            })
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        viewController.present(ac, animated: true)
        
    }
    
}
