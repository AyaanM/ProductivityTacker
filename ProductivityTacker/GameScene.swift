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
    var timerCounting: Bool = false
    var timeString: String = "00:00:00"
    
    func toggle() {
        //toggle timer on off
        if (timerCounting) { //if button tapped (timer running) and already counting, stop timer
            timerCounting = false
            timer.invalidate()
        } else { //if not already counting (timer stopped), run timer
            timerCounting = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true) // fires every one second to increase count by 1
        }
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
        
        timeString = "\(String(format: "%02d", hours)): \(String(format: "%02d", minutes)): \(String(format: "%02d", seconds))"
        return timeString
        
    }
    
    func resetTimer() {
        // reset the timer by setting count to 0
        count = 0
        timer.invalidate() //stop timer
        timerCounting = false
        timeString = getTimeString(seconds: count)
    }
}

class GameScene: SKScene {
    
    //initialize stopwatch class
    var watch = Stopwatch()
    
    var startStopLabel: SKLabelNode!
    var timerCounting: Bool = false {
        didSet {
            if timerCounting {
                startStopLabel.text = "Stop"
            } else {
                startStopLabel.text = "Start"
            }
        }
    }
    
    var resetLabel: SKLabelNode!
    var timeLabel: SKLabelNode!
    var time = "00:00:00"
        
    override func didMove(to view: SKView) {
        
        //create the time display
        timeLabel = SKLabelNode(fontNamed: "Hoefler Text")
        timeLabel.fontSize = 40
        timeLabel.text = "00:00:00"
        timeLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - 125)
        addChild(timeLabel)
        
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
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if let touch = touches.first {
                    let location = touch.location(in: self)
                    let objects = nodes(at: location)
            
                if objects.contains(startStopLabel) {
                    watch.toggle()
                    time = watch.timeString
                    if (watch.timerCounting) {
                        timerCounting = true
                    } else {
                        timerCounting = false
                    }
                }
                
                if objects.contains(resetLabel) {
                    watch.resetTimer()
                    timerCounting = false
                }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
            super.update(currentTime)
            
            // Update the time label on every frame
            timeLabel.text = watch.timeString
        }
    
}
