//
//  MenuTableViewController.swift
//  NIFTY
//
//  Created by William Schmitt and Yong Li Dich on 12/5/15.
//  Copyright © 2015 NIFTY. All rights reserved.
//
//  Code adapted from http://www.raywenderlich.com/78568/create-slide-out-navigation-panel-swift
//

import UIKit

class MenuTableViewController: UITableViewController {

    // MARK: Table cell selection

    //if user clicks a cell, change the headlines in the sidebar menu
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // variable declarations
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRowAtIndexPath(indexPath!)! as UITableViewCell
        let headlinesTitle = (cell.textLabel?.text)!
        var headlinesURL = "https://news.google.com/news?cf=all&hl=en&pz=1&ned=us&output=rss"
        
        // append appropriate url snippet depending on news type
        switch headlinesTitle {
        case "Top Stories":
            break
        case "World News":
            headlinesURL += "&topic=w"
        case "U.S. News":
            headlinesURL += "&topic=n"
        case "Business":
            headlinesURL += "&topic=b"
        case "Technology":
            headlinesURL += "&topic=tc"
        case "Entertainment":
            headlinesURL += "&topic=e"
        case "Sports":
            headlinesURL += "&topic=s"
        case "Science":
            headlinesURL += "&topic=snc"
        case "Health":
            headlinesURL += "&topic=m"
        default:
            break
        }
        
        
        
        // MARK: Navigation 
        
        // create new headlines view
        let containerViewController = ContainerViewController()
        containerViewController.headlinesURL = headlinesURL
        containerViewController.headlinesTitle = headlinesTitle
        
        // Present headline view
        presentViewController(containerViewController, animated: true, completion: nil)
    }
}
