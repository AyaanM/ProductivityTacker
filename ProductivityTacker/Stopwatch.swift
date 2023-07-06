//
//  Stopwatch.swift
//  ProductivityTacker
//
//  Created by Ayaan Merchant on 2023-07-04.
//

import Foundation
import UIKit

class Stopwatch {
    
    var timer: Timer = Timer()
    var timerName: String
    var timerCounting: Bool = false //if timer is running or not
    
    // for the timer functions
    var elapsedTime: Int = 0 //count in seconds for stopwatch timer
    var elapsedTimeString: String = "00:00"
    
    // for the countdown functions
    var remainingTimeString: String = "00:00"
    var remainingTime: Int = 0 //default values it always switches to if nothing provided
    
    init(timerName: String) {
        self.timerName = timerName
        self.resetTimer() //do this initially to have defaults set
    }
    
    // FUNCTIONS FOR THE STOPWATCH TIMER
    func stopTimer() {
        //stop the timer by invalidating it
        timer.invalidate()
        timerCounting = false
    }
    
    func startTimer() {
        //start the timer, take in remaining time to get time session
        timerCounting = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true) // fires every one second to increase count by 1
    }
    
    @objc func timerCounter() {
        //increase count (seconds) and get timer string
        elapsedTime += 1
        remainingTime -= 1
        
        elapsedTimeString = getTimeString(seconds: elapsedTime)
        remainingTimeString = getTimeString(seconds: remainingTime)
    }
 
    func getTimeString(seconds: Int) -> String {
        //return time in hours seconds minutes
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        
        if timerName == "focus" {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    func resetTimer() {
        // reset the timer by setting count to 0
        elapsedTime = 0
        if timerName == "focus" {
            remainingTime = 1500
        } else {
            remainingTime = 300
        }
        
        timer.invalidate() //stop timer
        timerCounting = false
        elapsedTimeString = getTimeString(seconds: elapsedTime)
        remainingTimeString = getTimeString(seconds: remainingTime)
    }
    
}
