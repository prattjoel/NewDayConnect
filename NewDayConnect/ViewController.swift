//
//  ViewController.swift
//  NewDayConnect
//
//  Created by Joel on 12/24/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        YouTubeClient.sharedInstance().getVideos { (success, result, error) in
            if success {
                print("success")
            } else {
                print("error with getVideos Request: \(error)")
            }
        }
        
//        YouTubeClient.sharedInstance().getPlaylistID { (success, result, error) in
//            if success {
//                if let ID = result {
//                    print("playlist ID is \(ID)")
//                } else {
//                    print("result from getPlaylistID is empty")
//                }
//                
//            } else {
//                print("error getting playlist ID: \(error)")
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

