//
//  GameViewController.swift
//  ProductivityTacker
//
//  Created by Ayaan Merchant on 2023-07-01.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var currentGame: GameScene?
    
    let pickerViewController = PickerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene //assign optionally to current game
                currentGame?.viewController = self //set viewController as self to establish communication
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func checkTimesUp() {
        
        if currentGame!.focus.timerCounting == true {
            if currentGame!.focus.elapsedTime == currentGame!.focusRemaining {
                currentGame!.focus.stopTimer() //stop focus timer
                currentGame!.focus.elapsedTime = 0
                currentGame!.focusStartStopButton.text = "Start"
                
                let ac = UIAlertController(title: "Focus time up!", message: "You can head on you break now, you can choose to continue focus, and no more alerts will be sent", preferredStyle: .alert)
                
                ac.addAction(UIAlertAction(title: "Take Break", style: .default, handler: { _ in
                    self.currentGame!.startBreak()
                }))
                ac.addAction(UIAlertAction(title: "Continue", style: .default))
                
                present(ac, animated: true)
            }
        }
        
        if currentGame!.rest.timerCounting == true {
            if currentGame!.rest.elapsedTime == currentGame!.restRemaining {
                currentGame!.rest.stopTimer()
                currentGame!.restStartStopButton.text = "Start"
                currentGame!.rest.elapsedTime = 0
                
                let ac = UIAlertController(title: "Break time up!", message: "You must now focus again!", preferredStyle: .alert)
                
                ac.addAction(UIAlertAction(title: "Focus Mode", style: .default, handler: { _ in
                    self.currentGame!.startFocus()
                }))
                
                present(ac, animated: true)
            }
        }
    }
    
    func pickTime(timerName: String, currentTime: Int) {
        
        present(pickerViewController, animated: true, completion: nil)
        
//        if timerName == "focus" {
//            if timeSelected != currentTime { // if the selected time isn't the time passed in, change it
//                print(timeSelected)
//                // currentGame?.focusRemaining = timeSelected
//            }
//        } else {
//            if timeSelected != currentTime { // if the selected time isn't the time passed in, change it
//                // currentGame?.restRemaining = timeSelected
//            }
//        }
        
        if timeSelected != currentTime { // if the selected time isn't the time passed in, change it
            print(timeSelected)
            // currentGame?.focusRemaining = timeSelected
        }
        print(timeSelected)
        
        
//        if timerName == "focus" {
//            pickerViewController.timeOptions = [("10 minutes", 600), ("25 minutes", 1500), ("45 minutes", 2700), ("1 hour", 3600), ("2 hours", 7200), ("3 hours", 10800)]
//        } else {
//            pickerViewController.timeOptions = [("5 minutes", 300), ("10 minutes", 600), ("15 minutes", 900), ("30 minutes", 1800)]
//        }
    }
}

var timeSelected: Int = 0

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let pickerView = UIPickerView() //import the interface of the picker view
    
    var timeOptions: [(String, Int)] = [("10 minutes", 600), ("25 minutes", 1500), ("45 minutes", 2700), ("1 hour", 3600), ("2 hours", 7200), ("3 hours", 10800)]
    
    var selectedTime: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self //responsible for the appearance of picker
        pickerView.dataSource = self //manages the data source

        pickerView.backgroundColor = UIColor.black
        pickerView.setValue(UIColor.white, forKey: "textColor")
        pickerView.layer.cornerRadius = 10.0
        view.addSubview(pickerView) //add view before adding constraints to add to hierchy
        pickerView.translatesAutoresizingMaskIntoConstraints = false

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default) //set to empty uiImage
        toolbar.tintColor = .yellow
        toolbar.setItems([spacer, cancelButton, spacer, doneButton, spacer], animated: true) //spacers to give toolbar a nicer look
        view.addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([ //contraints for actual picker view and for tool bar
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            toolbar.leadingAnchor.constraint(equalTo: pickerView.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: pickerView.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: pickerView.bottomAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeOptions[row].0 //the title that should be displayed on each row
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTime = timeOptions[row].1 //assign the selected time value to the variable
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //this is how many things are displayed
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeOptions.count //counts everything in array and displays it
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func doneButtonTapped() {
        timeSelected = selectedTime
        dismiss(animated: true)
        return
    }
    
}

