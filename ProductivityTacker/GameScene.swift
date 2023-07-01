//
//  GameScene.swift
//  ProductivityTacker
//
//  Created by Ayaan Merchant on 2023-07-01.
//

import SpriteKit
import GameplayKit

class Stopwatch {
    
    var timer: Timer = Timer()
    var count: Int = 0
    var timerCounting: Bool = false
    var timeString: String = ""
    
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
        var timeString = getTimeString(seconds: count)
    }
 
    func getTimeString(seconds: Int) -> String {
        //return time in hours seconds minutes
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        
        timeString += "\(String(format: "%02d", hours)): "
        timeString += "\(String(format: "%02d", minutes)): "
        timeString += "\(String(format: "%02d", seconds))"
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
    
    //initialize stopwatch class
    var watch = Stopwatch()
    
    var timeLabel: SKLabelNode!
    var time = "00:00:00" {
        didSet {
            timeLabel.text = time
        }
    }
        
    override func didMove(to view: SKView) {
        
        //create the timeLabel
        timeLabel = SKLabelNode(fontNamed: "Hoefler Text")
        timeLabel.fontSize = 40
        timeLabel.text = "00:00:00"
        timeLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - 125)
        addChild(timeLabel)
    }
    
}
