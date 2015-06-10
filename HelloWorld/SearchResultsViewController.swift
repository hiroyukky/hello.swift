//
//  ViewController.swift
//  HelloWorld
//
//  Created by hiroyukky on 6/10/15.
//  Copyright © 2015 hiroyukky. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {

    @IBOutlet var appsTableView : UITableView!
    var tableData = []
    let kCellIdentifier: String = "SearchResultCell"
    var imageCache = [String:UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let api = APIController()
        api.delegate = self
        api.searchItunesFor("gocco")
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
        //let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "appCell")
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell?
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: kCellIdentifier)
        }
        if let rowData: NSDictionary = self.tableData[indexPath.row] as? NSDictionary,
            urlString      = rowData["artworkUrl60"] as? String,
            imgURL         = NSURL(string: urlString),
            formattedPrice = rowData["formattedPrice"] as? String,
            //imgData        = NSData(contentsOfURL: imgURL),
            trackName      = rowData["trackName"] as? String {
                cell!.detailTextLabel?.text = formattedPrice
                cell!.textLabel?.text       = trackName
                cell!.imageView?.image      = UIImage(named: "Blank52")
                if let img = imageCache[urlString] {
                    cell!.imageView?.image = img
                }else{
                    let request: NSURLRequest = NSURLRequest(URL: imgURL)
                    let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
                        //NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: {(response, data , error) -> Void in
                        if (error == nil) {
                            let image = UIImage(data: data!)
                            self.imageCache[urlString] = image
                            dispatch_async(dispatch_get_main_queue(), {
                                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath){
                                    cellToUpdate.imageView?.image = image
                                }
                            })
                        }else{
                            print("error \(error?.description)")
                        }
                    })
                    task?.resume()
                }
                
        }
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let rowData = self.tableData[indexPath.row] as? NSDictionary,
            trackName      = rowData["trackName"] as? String,
            formattedPrice = rowData["formattedPrice"] as? String {
                let alert = UIAlertController(title: trackName, message: formattedPrice, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = results
            self.appsTableView!.reloadData()
        })
    }
}

