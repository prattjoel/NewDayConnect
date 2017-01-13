//
//  PresentAlertController.swift
//  NewDayConnect
//
//  Created by Joel on 1/12/17.
//  Copyright © 2017 Joel Pratt. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentAlertContoller(title: String, message: String) {
        let alertContoller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertContoller.addAction(okAction)
        
        present(alertContoller, animated: true, completion: nil)
    }
}
