//
//  StartPetitionViewController.swift
//  NIFTY
//
//  Created by William Schmitt and Yong Li Dich on 12/4/15.
//  Copyright © 2015 NIFTY. All rights reserved.
//

import UIKit

class StartPetitionViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var startPetitionWebView: UIWebView!
    
    
    
    // MARK: Configure View

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change view title
        title = "Start a Petition!"
        
        // Load Start a Petition webpage
        let startPetitionURL : NSURL = NSURL(string: "https://www.change.org/start-a-petition/")!
        let request : NSURLRequest = NSURLRequest(URL: startPetitionURL)
        startPetitionWebView.loadRequest(request)
    }
}
