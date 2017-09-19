//
//  XMLParser.swift
//  RSSReader
//
//  Created by William Schmitt on 12/2/15.
//  Copyright © 2015 William Schmitt. All rights reserved.
//
//  Code adapted from http://www.appcoda.com/building-rss-reader-using-uisplitviewcontroller-uipopoverviewcontroller/
//

import UIKit



// MARK: Protocols
@objc protocol XMLParserDelegate {
    func parsingWasFinished()
}

class XMLParser: NSObject, NSXMLParserDelegate {
    
    
    
    // MARK: Properties
    var arrParsedData = [Dictionary<String, String>]()
    var currentDataDictionary = Dictionary<String, String>()
    var currentElement = ""
    var foundCharacters = ""
    var delegate: XMLParserDelegate?
    
    
    
    // MARK: Parse
    
    // initialize parser
    func startParsingWithContentsOfURL(rssURL: NSURL) {
        let parser = NSXMLParser(contentsOfURL: rssURL)
        parser!.delegate = self
        parser!.parse()
    }
    
    // capture RSS element title
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
    }
    
    // if element (title/link) is desired, save it
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if currentElement == "title" || currentElement == "link" {
            foundCharacters += string
        }
    }
    
    //save element in array of desired elements (section), and if end of section, save in array of sections
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if !foundCharacters.isEmpty {
            currentDataDictionary[currentElement] = foundCharacters
            
            foundCharacters = ""
            
            if currentElement == "link" {
                arrParsedData.append(currentDataDictionary)
            }
        }
    }
    
    //parser reached end of RSS
    func parserDidEndDocument(parser: NSXMLParser) {
        arrParsedData.removeRange(0..<2)
        delegate?.parsingWasFinished()
    }
    
    //handle errors by logging them to the screen
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print(parseError.description)
    }
    
    func parser(parser: NSXMLParser, validationErrorOccurred validationError: NSError) {
        print(validationError.description)
    }
}
