//
//  APIController.swift
//  HelloWorld
//
//  Created by hiroyukky on 6/10/15.
//  Copyright © 2015 hiroyukky. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSArray)
}

class APIController {
    var delegate: APIControllerProtocol
    init(delegate: APIControllerProtocol){
        self.delegate = delegate
    }
    func get(path: String) {
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, err1 -> Void in
            if(err1 != nil){
                print(err1!.localizedDescription)
            }
            if let jsonResult = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                if let results: NSArray = jsonResult["results"] as? NSArray {
                    self.delegate.didReceiveAPIResults(results)
                }
            }
        })
        task!.resume()
    }

    func searchItunesFor(searchItem: String){

        let itunesSearchTerm = searchItem.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding){
            let urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album"
            get(urlPath)
        }
    }

    func lookupAlbum(collectionId: Int) {
        get("https://itunes.apple.com/lookup?id=\(collectionId)&entity=song")
    }

}