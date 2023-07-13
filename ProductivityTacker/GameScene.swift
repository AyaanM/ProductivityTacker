//
//  GameScene.swift
//  ProductivityTacker
//
//  Created by Ayaan Merchant on 2023-07-01.
//

import UIKit
import SpriteKit

class GameScene: SKScene {
    
    weak var viewController: GameViewController? //define the game scene
    
    //initialize classes
    var focus = Stopwatch(timerName: "focus")
    var rest = Stopwatch(timerName: "rest")
    
    //define buttons
    var focusStartStopButton: SKLabelNode!
    var restStartStopButton: SKLabelNode!
    
    //define displays
    var focusElapsedDisplay: SKLabelNode!
    var focusRemainingDisplay: SKLabelNode!
    
    var restElapsedDisplay: SKLabelNode!
    var restRemainingDisplay: SKLabelNode!
    
    //define standalone labels
    var focusLabel: SKLabelNode!
    var restLabel: SKLabelNode!
    
    //define vars
    var focusRemaining: Int = 0
    var restRemaining: Int = 0
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.size = CGSize(width: self.size.width, height: self.size.height)
        background.alpha = 0.5
        background.blendMode = .replace //draw the node
        background.zPosition = -1
        addChild(background)
        
        //SKNODES FOR THE FOCUS DISPLAY
        //create the focus standalone label
        focusLabel = SKLabelNode(fontNamed: "Hoefler Text")
        focusLabel.fontSize = 50
        focusLabel.text = "Focus Session"
        focusLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.5)
        addChild(focusLabel)
        
        //create the focus timer display
        focusRemainingDisplay = SKLabelNode(fontNamed: "Hoefler Text")
        focusRemainingDisplay.fontSize = 40
        focusRemainingDisplay.text = "25:00"
        focusRemainingDisplay.position = CGPoint(x: self.size.width / 3, y: (self.size.height / 1.5) - (focusLabel.frame.height*2))
        addChild(focusRemainingDisplay)
        
        //create the focus stopwatch display
        focusElapsedDisplay = SKLabelNode(fontNamed: "Hoefler Text")
        focusElapsedDisplay.fontSize = 40
        focusElapsedDisplay.text = "00:00"
        focusElapsedDisplay.position = CGPoint(x: self.size.width / 1.5, y: (self.size.height / 1.5) - (focusLabel.frame.height*2))
        addChild(focusElapsedDisplay)
        
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
        restRemainingDisplay = SKLabelNode(fontNamed: "Hoefler Text")
        restRemainingDisplay.fontSize = 35
        restRemainingDisplay.text = "05:00"
        restRemainingDisplay.position = CGPoint(x: self.size.width / 3, y: (self.size.height / 1.5) - (focusLabel.frame.height*8.5))
        addChild(restRemainingDisplay)
        
        //create the breaktime stopwatch display
        restElapsedDisplay = SKLabelNode(fontNamed: "Hoefler Text")
        restElapsedDisplay.fontSize = 35
        restElapsedDisplay.text = "00:00"
        restElapsedDisplay.position = CGPoint(x: self.size.width / 1.5, y: (self.size.height / 1.5) - (focusLabel.frame.height*8.5))
        addChild(restElapsedDisplay)
        
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
            
            if objects.contains(focusRemainingDisplay) {
                //choose what time you want to focus for, default is 25:00
                if !focus.timerCounting { //if the proTimer isn't already working
                    viewController!.pickTime(timerName: "focus")
                }
            }
            
            if objects.contains(restRemainingDisplay) {
                //choose what time you want to rest for, default is 5:00
                if !rest.timerCounting { //if the proTimer isn't already working
                    viewController!.pickTime(timerName: "break")
                }
            }
            
            if objects.contains(focusStartStopButton) {
                startFocus()
            }
            
            if objects.contains(restStartStopButton) {
                startBreak()
            }
        }
    }
    
    func startFocus() {
        if !focus.timerCounting {
            focus.startTimer() //send in the seconds of remaining time
            rest.resetTimer()
            focusStartStopButton.text = "Stop"
            restStartStopButton.text = "Start"
        } else {
            focus.stopTimer()
            focusStartStopButton.text = "Start"
        }
    }
    
    func startBreak() {
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
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // Update the time label on every frame
        focusElapsedDisplay.text = focus.elapsedTimeString
        restElapsedDisplay.text = rest.elapsedTimeString
        
        focusRemainingDisplay.text = focus.remainingTimeString
        restRemainingDisplay.text = rest.remainingTimeString
        
        viewController!.checkTimesUp()
        
    }
    
}
    

