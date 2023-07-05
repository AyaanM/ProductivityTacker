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
        timerCounting = false
        timeString = getTimeString(seconds: count)
    }
    
}

class viewController: UIViewController {
    
    func pickTime() {
        
        guard let viewController = self.view?.window?.rootViewController else {
                return
            }
        
        let ac = UIAlertController(title: "Pick Time", message: "Pick the time you would like to focus for, a notification will be sent once you have surpassed the time. If you pick 'I will decide', no notification will be sent and you can continue uninterrupted focus!", preferredStyle: .alert)
        
        let times = ["10 minutes", "25 minutes", "1 hour", "2 hours", "3 hours", "I will decide"]
        
        for time in times {
            ac.addAction(UIAlertAction(title: time, style: .default))
        }
        
        ac.addAction(UIAlertAction(title: "Cancle", style: .default))
        
        viewController.present(ac, animated: true)
    }
}
