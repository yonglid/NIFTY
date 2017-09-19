//
//  ArticleViewController.swift
//  NIFTY
//
//  Created by William Schmitt and Yong Li Dich on 12/3/15.
//  Copyright © 2015 NIFTY. All rights reserved.
//
//  Code adapted from http://www.appcoda.com/building-rss-reader-using-uisplitviewcontroller-uipopoverviewcontroller/
//

import UIKit

class ArticleViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    
    // MARK: Properties

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var suggestionButtonItem: UIBarButtonItem!
    @IBOutlet weak var articleWebView: UIWebView!
    var articleURL: NSURL!
    var headline: String!
    
    
    
    // MARK: Configure View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if article URL exists, load article webpage
        if articleURL != nil {
            let request : NSURLRequest = NSURLRequest(URL: articleURL)
            articleWebView.loadRequest(request)
        }
    }
    
    
    
    // MARK: Actions
    
    // when want to help button is clicked, show petitions
    @IBAction func showSuggestions(sender: AnyObject) {
        
        // create petition view
        let petitionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("idPetitionViewController") as! PetitionViewController
        petitionViewController.headline = headline
        
        // present petition view
        self.navigationController?.pushViewController(petitionViewController, animated: true)
    }
}
