//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //With self typing animating logic
        animatingTitleLabel()
        
        // Using CLTypingLabel pod for animating
        //titleLabel.text = "⚡️FlashChat"
    }
    
    //MARK:- Helper Functions
    func animatingTitleLabel(){
        //For typing animation
        titleLabel.text = ""
        var charIndex = 0.0
        
        let titleText = Constants.appName
        for letter in titleText {
            //print(0.1*charIndex, letter)
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) {(timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }
    

}
