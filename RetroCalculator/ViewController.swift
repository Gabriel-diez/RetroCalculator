//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Gabriel Diez on 27/01/2017.
//  Copyright © 2017 Gabriel Diez. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var outputLbl: UILabel!
    var btnSound: AVAudioPlayer!

    var currentOperation = Operation.Empty
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        runningNumber += "\(sender.tag)"
        outputLbl.text = runningNumber
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(operation: .Multiply)
    }
    
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(operation: .Divide)

    }
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(operation: .Subtract)

    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(operation: .Add)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(operation: currentOperation)
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        btnSound.play()
    }
    
    func processOperation(operation: Operation) {
        playSound()
        if currentOperation != Operation.Empty {
            // A user selected an operator and then an another
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
                
                switch currentOperation {
                    case Operation.Multiply:
                        result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                    case Operation.Divide:
                        result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                    case Operation.Subtract:
                        result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                    default:
                        result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                
                leftValStr = result
                outputLbl.text = result
            }
            currentOperation = operation
        } else {
            // first time an operator has been pressed
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }

}

