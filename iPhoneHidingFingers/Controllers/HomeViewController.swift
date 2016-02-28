//
//  ViewController.swift
//  iPhoneHidingFingers
//
//  Created by Rafael Ferreira on 2/23/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

import UIKit
import Darwin

/** The view controller for the home view at `Main`.storyboard. */
public class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var attemptTextField: UITextField!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var numberToHide: Int?
    private let notificationCenter = NSNotificationCenter.defaultCenter()
    private var originalbackgroundColor: UIColor?
    
    // MARK: De initializers
    
    deinit {
        // Remove all observers that we need to put on this view controller.
        notificationCenter.removeObserver(self)
    }
    
    // MARK: UIView methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Storage the original background color.
        originalbackgroundColor = view.backgroundColor
        
        generateHideNumber()
        addDismissKeyboard()
        addObserverToKeyboard()
    }
    
    // MARK: UITextFieldDelegate methods
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var newString = String()
        
        if let currentText = textField.text {
            newString = currentText + string
        }
        
        let count = newString.characters.count
        
        guard let newNumber = Int(newString) else {
            return false
        }
        
        return newNumber <= 10 && count <= 2
    }
    
    // MARK: Helper methods
    
    func addDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func addObserverToKeyboard() {
        notificationCenter.addObserver(self, selector: "keyboardWillShowed:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func hideKeyboard() {
        self.attemptTextField.resignFirstResponder()
    }
    
    func keyboardWillShowed(notification: NSNotification) {
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.topConstraint.constant = 10
            self.bottomConstraint.constant = 10
            
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.topConstraint.constant = 35
            self.bottomConstraint.constant = 35
            
            self.view.layoutIfNeeded()
        })
    }
    
    private func checkCorrectAnswer() -> Bool {
        if let typedNumber = attemptTextField.text {
            guard typedNumber.characters.count > 0 else {
                return false
            }
            
            let number: Int = Int(typedNumber)!
            let isCorrect: Bool = number == numberToHide
            
            if isCorrect {
                generateHideNumber()
            }
            
            return isCorrect
        }
        
        return false
    }
    
    private func generateHideNumber() {
        let random = arc4random_uniform(10)
        
        numberToHide = Int(random)
        print(numberToHide!)
    }
    
    // MARK: Action methods
    
    @IBAction func tryFindOutAction() {
        let isCorrect: Bool = checkCorrectAnswer()
        let imageName = isCorrect ? "Awesome" : "Failure"
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.view.backgroundColor = isCorrect ? UIColor(red: 1, green: 0.87, blue: 0, alpha: 1) : UIColor.redColor()
            self.statusImageView.image = UIImage(imageLiteral: imageName)
            }, completion: { (finished: Bool) -> Void in
                if finished {
                    let delay: Double = isCorrect ? 3.0 : 0
                    
                    UIView.animateWithDuration(1.0, delay: delay, options: .BeginFromCurrentState, animations: { () -> Void in
                        self.view.backgroundColor = self.originalbackgroundColor
                        }, completion: { (finished: Bool) -> Void in
                            self.statusImageView.image = UIImage(imageLiteral: "Charade")
                            self.attemptTextField.text = String()
                    })
                }
        })
    }
    
}