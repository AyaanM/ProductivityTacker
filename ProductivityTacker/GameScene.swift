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
    var focus = Stopwatch(timerName: "focus")
    var rest = Stopwatch(timerName: "rest")
    
    //define buttons
    var focusStartStopButton: SKLabelNode!
    var restStartStopButton: SKLabelNode!
    
    //define displays
    var focusStopwatchDisplay: SKLabelNode!
    var focusTimerDisplay: SKLabelNode!
    
    var restStopwatchDisplay: SKLabelNode!
    var restTimerDisplay: SKLabelNode!
    
    //define standalone labels
    var focusLabel: SKLabelNode!
    var restLabel: SKLabelNode!
        
    override func didMove(to view: SKView) {
        
        //SKNODES FOR THE FOCUS DISPLAY
        //create the focus standalone label
        focusLabel = SKLabelNode(fontNamed: "Hoefler Text")
        focusLabel.fontSize = 50
        focusLabel.text = "Focus Session"
        focusLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.5)
        addChild(focusLabel)
        
        //create the focus timer display
        focusTimerDisplay = SKLabelNode(fontNamed: "Hoefler Text")
        focusTimerDisplay.fontSize = 40
        focusTimerDisplay.text = focus.remainingTimeString
        focusTimerDisplay.position = CGPoint(x: self.size.width / 3, y: (self.size.height / 1.5) - (focusLabel.frame.height*2))
        addChild(focusTimerDisplay)
        
        //create the focus stopwatch display
        focusStopwatchDisplay = SKLabelNode(fontNamed: "Hoefler Text")
        focusStopwatchDisplay.fontSize = 40
        focusStopwatchDisplay.text = rest.remainingTimeString
        focusStopwatchDisplay.position = CGPoint(x: self.size.width / 1.5, y: (self.size.height / 1.5) - (focusLabel.frame.height*2))
        addChild(focusStopwatchDisplay)
        
        //create start focus button button
        focusStartStopButton = SKLabelNode(fontNamed: "Hoefler Text")
        focusStartStopButton.fontSize = 40
        focusStartStopButton.text = "Start"
        focusStartStopButton.position = CGPoint(x: self.size.width / 2, y: (self.size.height / 1.5) - (focusLabel.frame.height*4))
        addChild(focusStartStopButton)
        
        //SK NODES FOR THE BREAK DISPLAY
        //create the break label standalone display
        restLabel = SKLabelNode(fontNamed: "Hoefler Text")
        restLabel.fontSize = 40
        restLabel.text = "Break Session"
        restLabel.position = CGPoint(x: self.size.width / 2, y: (self.size.height / 1.5) - (focusLabel.frame.height*6.5))
        addChild(restLabel)
        
        //create the breaktime timer display
        restTimerDisplay = SKLabelNode(fontNamed: "Hoefler Text")
        restTimerDisplay.fontSize = 35
        restTimerDisplay.text = "05:00"
        restTimerDisplay.position = CGPoint(x: self.size.width / 3, y: (self.size.height / 1.5) - (focusLabel.frame.height*8.5))
        addChild(restTimerDisplay)
        
        //create the breaktime stopwatch display
        restStopwatchDisplay = SKLabelNode(fontNamed: "Hoefler Text")
        restStopwatchDisplay.fontSize = 35
        restStopwatchDisplay.text = "00:00"
        restStopwatchDisplay.position = CGPoint(x: self.size.width / 1.5, y: (self.size.height / 1.5) - (focusLabel.frame.height*8.5))
        addChild(restStopwatchDisplay)
        
        //create start focus button button
        restStartStopButton = SKLabelNode(fontNamed: "Hoefler Text")
        restStartStopButton.fontSize = 35
        restStartStopButton.text = "Start"
        restStartStopButton.position = CGPoint(x: self.size.width / 2, y: (self.size.height / 1.5) - (focusLabel.frame.height*10))
        addChild(restStartStopButton)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if let touch = touches.first {
                    let location = touch.location(in: self)
                    let objects = nodes(at: location)
                
                if objects.contains(focusTimerDisplay) {
                    //choose what time you want to focus for, default is 25:00
                    if !focus.timerCounting { //if the proTimer isn't already working
                        focus.resetTimer()
                        pickTime(timerName: "focus")
                    }
                }
                
                if objects.contains(restTimerDisplay) {
                    //choose what time you want to rest for, default is 5:00
                    if !rest.timerCounting { //if the proTimer isn't already working
                        rest.resetTimer() //to reset the elapsed time
                        pickTime(timerName: "break")
                    }
                }
            
                if objects.contains(focusStartStopButton) {
                    
                    if !focus.timerCounting {
                        focus.startTimer() //send in the seconds of remaining time
                        rest.stopTimer()
                        focusStartStopButton.text = "Stop"
                        restStartStopButton.text = "Start"
                    } else {
                        focus.stopTimer()
                        focusStartStopButton.text = "Start"
                    }
                }
                
                if objects.contains(restStartStopButton) {
                    if !rest.timerCounting {
                        rest.startTimer() //send in the seconds of remaining time
                        focus.stopTimer()
                        restStartStopButton.text = "Stop"
                        focusStartStopButton.text = "Start"
                    } else {
                        rest.stopTimer()
                        restStartStopButton.text = "Start"
                    }
                }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    
        // Update the time label on every frame
        focusStopwatchDisplay.text = focus.elapsedTimeString
        restStopwatchDisplay.text = rest.elapsedTimeString
        
        focusTimerDisplay.text = focus.remainingTimeString
        restTimerDisplay.text = rest.remainingTimeString
        
        }
    
    func pickTime(timerName: String) {
        // Take in what type of timer to set and pick at what time the timer should be set
        var messages: String
        var times: [String: Int] = [:] //the time in string format:the seconds in int format
        
        guard let viewController = self.view?.window?.rootViewController else {
                return
            }
        
        // define action for different timer types
        if timerName == "focus" { //if the focus timer is toggled
            messages = "Pick the time you would like to focus for, 'run timer already' means no set time (uniterrupted focus)"
            times = ["10 minutes": 600, "25 minutes": 1500, "45 minutes": 2700, "1 hour": 3600, "2 hours": 7200, "3 hours": 10800]
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
                if timerName == "focus" {
                    focus.remainingTime = tInt
                    focus.remainingTimeString = self.focus.getTimeString(seconds: tInt)
                } else {
                    rest.remainingTime = tInt
                    rest.remainingTimeString = self.rest.getTimeString(seconds: tInt)
                }
            })
        }
        
        viewController.present(ac, animated: true)
        
    }
    
}
