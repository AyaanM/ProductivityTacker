//
//  GameScene.swift
//  ProductivityTacker
//
//  Created by Ayaan Merchant on 2023-07-01.
//

import SpriteKit

class Stopwatch {
    
    var timer: Timer = Timer()
    var count: Int = 0
    var timeString: String = "00:00"
    
    func stopTimer() {
        //stop the timer by invalidating it
        timer.invalidate()
    }
    
    func startTimer() {
        //start the timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true) // fires every one second to increase count by 1
    }
    
    @objc func timerCounter() {
        //increase count (seconds) and get timer string
        count += 1
        timeString = getTimeString(seconds: count)
    }
 
    func getTimeString(seconds: Int) -> String {
        //return time in hours seconds minutes
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        
        timeString = "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        
        if count >= 3600 { //if 1hr has been reached
            timeString = "\(String(format: "%02d", hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        }
        return timeString
        
    }
    
    func resetTimer() {
        // reset the timer by setting count to 0
        count = 0
        timer.invalidate() //stop timer
        timeString = getTimeString(seconds: count)
    }
    
}

class GameScene: SKScene {
    
    //initialize classes
    var proTimer = Stopwatch()
    var breakTimer = Stopwatch()
    
    //define buttons
    var takeBreakLabel: SKLabelNode!
    var resetLabel: SKLabelNode!
    var startStopLabel: SKLabelNode!
    var timerCounting: Bool = false { //timer not count
        didSet {
            if timerCounting == true { //time is counting
                startStopLabel.text = "Stop"
            } else { //timer not counting
                startStopLabel.text = "Start"
            }
        }
    }
    
    //define displays
    var breakTimeDisplay: SKLabelNode!
    var timeDisplay: SKLabelNode!
    var proTime = "00:00:00"
    var breakTime = "00:00"
        
    override func didMove(to view: SKView) {
        
        //create the productivity time display
        timeDisplay = SKLabelNode(fontNamed: "Hoefler Text")
        timeDisplay.name = "time"
        timeDisplay.fontSize = 40
        timeDisplay.text = proTime
        timeDisplay.position = CGPoint(x: self.size.width / 2, y: self.size.height - 125)
        addChild(timeDisplay)
        
        //create start stop button
        startStopLabel = SKLabelNode(fontNamed: "Hoefler Text")
        startStopLabel.fontSize = 45
        startStopLabel.text = "Start"
        startStopLabel.position = CGPoint(x: self.size.width / 3, y: self.size.height - 200)
        addChild(startStopLabel)
        
        //create reset button
        resetLabel = SKLabelNode(fontNamed: "Hoefler Text")
        resetLabel.fontSize = 45
        resetLabel.text = "Reset"
        resetLabel.position = CGPoint(x: self.size.width / 1.5, y: self.size.height - 200)
        addChild(resetLabel)
        
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
            
                if objects.contains(startStopLabel) {
                    
                    if timerCounting {
                        proTimer.stopTimer()
                    } else {
                        proTimer.startTimer()
                    }
                    
                    
                    timerCounting = !timerCounting //toggle it so true/false vice versa
                    
                    breakTimer.resetTimer() //stop timer for break
                    
                    takeBreakLabel.isHidden = false //display break label
                    breakTimeDisplay.isHidden = false
                    
                }
                
                if objects.contains(resetLabel) {
                    proTimer.resetTimer()
                    timerCounting = false //now shows start
                }
                
                if objects.contains(takeBreakLabel) {
                    proTimer.stopTimer() //pause the protimer and start break timer
                    breakTimer.startTimer()
                    
                    takeBreakLabel.isHidden = true
                
                    timerCounting = false //now shows start
                }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
            super.update(currentTime)
        
            // Update the time label on every frame
            timeDisplay.text = proTimer.timeString
            breakTimeDisplay.text = breakTimer.timeString
        }
    
}
