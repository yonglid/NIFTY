//
//  HeadlinesTableViewController.swift
//  NIFTY
//
//  Created by William Schmitt and Yong Li Dich on 12/3/15.
//  Copyright © 2015 NIFTY. All rights reserved.
//
//  Code adapted from http://www.appcoda.com/building-rss-reader-using-uisplitviewcontroller-uipopoverviewcontroller/
//

import UIKit



// MARK: Protocols

// create protocol for displaying sliding sidebar menu
@objc
protocol HeadlinesTableViewControllerDelegate {
    optional func toggleMenuPanel()
    optional func collapseMenuPanel()
}

class HeadlinesTableViewController: UITableViewController, UISearchBarDelegate, XMLParserDelegate {
    
    // MARK: Properties
    var xmlParser: XMLParser!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var topStoriesButtonItem: UIBarButtonItem!
    var delegate: HeadlinesTableViewControllerDelegate?
    var headlinesURL: String!
  
    
    
    // MARK: Configure View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if displaying top stories, disable return to top stories button
        if title == "Top Stories" {
            topStoriesButtonItem.enabled = false
        } else
        {
            topStoriesButtonItem.enabled = true
        }
        
        //perform parse of Google News RSS Feed
        let url = NSURL(string: headlinesURL)
        xmlParser = XMLParser()
        xmlParser.delegate = self
        xmlParser.startParsingWithContentsOfURL(url!)
        
        // Configure search bar
        searchBar.delegate = self
        searchBar.placeholder = "Search for a News Topic or Article"
        searchBar.hidden = false
    }
    
    
    
    // MARK: Configure Table
    
    // define number of sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // define number of rows per section
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xmlParser.arrParsedData.count
    }
    
    //set up row height
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    // Populate table cells with article headlines
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath) as UITableViewCell
        
        let currentDictionary = xmlParser.arrParsedData[indexPath.row] as Dictionary<String, String>
        
        cell.textLabel?.text = currentDictionary["title"]
        
        return cell
    }
    
    //if user clicks a cell, show the link
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // load in article headlines and links
        let dictionary = xmlParser.arrParsedData[indexPath.row] as Dictionary<String, String>
        let articleLink = dictionary["link"]
        
        // create article view
        let articleViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("idArticleViewController") as! ArticleViewController
        articleViewController.articleURL = NSURL(string: articleLink!)
        
        // remove news source from article title and capitalize each word
        let index = dictionary["title"]!.rangeOfString("-", options: .BackwardsSearch)?.startIndex
        articleViewController.headline = dictionary["title"]!.substringToIndex(index!)
        articleViewController.title = articleViewController.headline.capitalizedString
        
        // present article view
        self.navigationController?.pushViewController(articleViewController, animated: true)
    }
    
    // parse finished
    func parsingWasFinished() {
        self.tableView.reloadData()
    }
    
    // search performed
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        var searchText = searchBar.text
        
        // set title of headline view
        self.title = searchText!.capitalizedString
        
        // format text for parsing
        searchText = searchText?.stringByReplacingOccurrencesOfString(" ", withString: "+")
        
        // perform parse
        let url = NSURL(string: "https://news.google.com/news?q=" + searchText! + "&cf=all&hl=en&pz=1&ned=us&output=rss")
        xmlParser = XMLParser()
        xmlParser.delegate = self
        xmlParser.startParsingWithContentsOfURL(url!)
        
        // if no news articles found, notify user
        if xmlParser.arrParsedData.count == 0 {
            let noArticles = ["title":"No articles found."]
            xmlParser.arrParsedData.append(noArticles)
            self.tableView.reloadData()
        }
        
        // enable return top stories button
        topStoriesButtonItem.enabled = true
        
        searchBar.text = ""
    }

    
    
    // MARK: Actions
    
    // When top stories button clicked, return top stories
    @IBAction func returnToTopStories(sender: UIBarButtonItem) {
        
        // reset title
        self.title = "Top Stories"
        
        //perform parse
        let url = NSURL(string: "https://news.google.com/news?cf=all&hl=en&pz=1&ned=us&output=rss")
        xmlParser = XMLParser()
        xmlParser.delegate = self
        xmlParser.startParsingWithContentsOfURL(url!)
        
        // disable top stories button
        topStoriesButtonItem.enabled = false
    }
    
    // when menu button clicked, show menu 
    @IBAction func showMenu(sender: UIBarButtonItem) {
        delegate?.toggleMenuPanel?() 
    }
    
}
