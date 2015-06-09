//
//  ViewController.swift
//  HelloWorld
//
//  Created by hiroyukky on 6/10/15.
//  Copyright © 2015 hiroyukky. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var appsTableView : UITableView!
    var tableData = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchItunesFor("gocco")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "appCell")
        if let rowData: NSDictionary = self.tableData[indexPath.row] as? NSDictionary,
            urlString      = rowData["artworkUrl60"] as? String,
            imgURL         = NSURL(string: urlString),
            formattedPrice = rowData["formattedPrice"] as? String,
            imgData        = NSData(contentsOfURL: imgURL),
            trackName      = rowData["trackName"] as? String? {
                cell.detailTextLabel?.text = formattedPrice
                cell.imageView?.image      = UIImage(data:imgData)
                cell.textLabel?.text       = trackName
        }

        /*
        cell.textLabel?.text = "Row : #\(indexPath.row)"
        cell.detailTextLabel?.text = "Subtitle #\(indexPath.row)"
        */
        return cell
    }

    func searchItunesFor(searchItem: String){
        let itunesSearchTerm = searchItem.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding){
            let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
            let url = NSURL(string: urlPath)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url!, completionHandler: {data, response, err1 -> Void in
                print("task completed")
                if(err1 != nil){
                    print(err1!.localizedDescription)
                }
                if let jsonResult = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    if let results: NSArray = jsonResult["results"] as? NSArray{
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableData = results
                            self.appsTableView!.reloadData()
                        })
                    }
                }
                
            })
            task!.resume()
        }
    }
}

