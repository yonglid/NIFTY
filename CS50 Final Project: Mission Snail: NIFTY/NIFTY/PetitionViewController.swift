//
//  PetitionViewController.swift
//  NIFTY
//
//  Created by William Schmitt and Yong Li Dich on 12/4/15.
//  Copyright © 2015 NIFTY. All rights reserved.
//

import UIKit

class PetitionViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var petitionWebView: UIWebView!
    var headline: String!
    
    
    
    // MARK: Configure View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set view title
        title = "Relevant Petitions"
        
        // If headline exists, load title
        if headline != nil {
            
            // load in 1000 most common English words
            let path = NSBundle.mainBundle().pathForResource("commonWords", ofType: "txt")
            let commonWords: String
            do {
                commonWords = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
            } catch _ as NSError {
                commonWords = ""
            }
            
            // if load worked, remove common words from headline for better petition searching
            if commonWords != "" {
                
                let commonWordsArr = commonWords.componentsSeparatedByString("\n")
                
                for commonWord in commonWordsArr {
                    headline = headline.stringByReplacingOccurrencesOfString(" " + commonWord + " ", withString: " ")
                }
            }
            
            // Replace spaces with + so headline can be appended to URL
            headline = headline.stringByReplacingOccurrencesOfString(" ", withString: "+")
            
            // Load relevant petitions based on headline
            let petitionURL : NSURL = NSURL(string: "https://www.change.org/search?q=" + headline)!
            let request : NSURLRequest = NSURLRequest(URL: petitionURL)
            petitionWebView.loadRequest(request)
        }
    }

    
    
    
    // MARK: Actions
    
    // If start a petition button clicked, load start a petition webpage
    @IBAction func startPetitionButtonItem(sender: UIBarButtonItem) {
        let startPetitionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("idStartPetitionViewController") as! StartPetitionViewController
        
        // Present start a petition view
        self.navigationController?.pushViewController(startPetitionViewController, animated: true)
    }

    


}
