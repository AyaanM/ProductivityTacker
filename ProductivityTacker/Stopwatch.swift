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
    var count: Int = 0 //count in seconds
    var timeString: String = "00:00"
    
    var timerCounting: Bool = false //if timer is running or not
    var timerType: String
    
    init(timerType: String) {
        self.timerType = timerType
    }
    
    func stopTimer() {
        //stop the timer by invalidating it
        timer.invalidate()
        timerCounting = false
    }
    
    func startTimer() {
        //start the timer
        timerCounting = true
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
        
        if timerType == "focus" {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    func resetTimer() {
        // reset the timer by setting count to 0
        count = 0
        timer.invalidate() //stop timer
        timerCounting = false
        timeString = getTimeString(seconds: count)
    }
    
}
