//
//  DonationViewController.swift
//  NewDayConnect
//
//  Created by Joel on 2/2/17.
//  Copyright © 2017 Joel Pratt. All rights reserved.
//

import Foundation
import UIKit

class DonationViewController: UIViewController {
    
    
    @IBAction func donate(_ sender: Any) {
        
        let app = UIApplication.shared
        let newDayUrl = "http://bit.ly/newdaygiving"
        
        let url = URL(string: "\(newDayUrl)")
        
        app.open(url!, options: [:], completionHandler: nil)
    }
}
