//
//  ViewController.swift
//  iPhoneHidingFingers
//
//  Created by Rafael Ferreira on 2/23/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

import UIKit

/** The view controller for the home view at `Main`.storyboard. */
public class HomeViewController: UIViewController {
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var attemptTextField: UITextField!
    
    private var numberToHide: Int?
    
    // MARK: UIView methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        generateHideNumber()
    }
    
    // MARK: Helper methods
    
    private func generateHideNumber() {
        let randomDouble: Double = drand48()
        let random: Double = randomDouble * 10
        
        numberToHide = Int(random)
        print(numberToHide!)
    }
    
    private func checkCorrectAnswer() -> Bool {
        if let typedNumber = attemptTextField.text {
            let number: Int = Int(typedNumber)!
            let isCorrect: Bool = number == numberToHide
            
            if isCorrect {
                generateHideNumber()
            }
            
            return isCorrect
        }
        
        return false
    }
    
    // MARK: Action methods
    
    @IBAction func tryFindOutAction() {
        let isCorrect: Bool = checkCorrectAnswer()
        let imageName = isCorrect ? "Awesome" : "Failure"
        
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            self.statusImageView.image = UIImage(imageLiteral: imageName)
            self.view.backgroundColor = isCorrect ? UIColor.greenColor() : UIColor.redColor()
            }) { (finished: Bool) -> Void in
                if (finished) {
                    self.statusImageView.image = UIImage(imageLiteral: "Charade")
                    self.attemptTextField.text = String()
                    self.view.backgroundColor = UIColor.blueColor()
                }
                
        }
    }
    
}

