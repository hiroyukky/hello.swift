//
//  DetailsViewController.swift
//  HelloWorld
//
//  Created by hiroyukky on 6/11/15.
//  Copyright © 2015 hiroyukky. All rights reserved.
//

import UIKit
import MediaPlayer

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    var album: Album?
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tracksTableView: UITableView!
    var tracks = [Track]()
    lazy var api : APIController = APIController(delegate: self)
    var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController()

    required init(coder aDecorder: NSCoder) {
        super.init(coder: aDecorder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageURL)!)!)
        titleLabel.text = self.album?.title
        if self.album != nil {
            api.lookupAlbum(album!.collectionId)
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier("TrackCell") as! TrackCell
        let track = tracks[indexPath.row]
        print("track : \(track.title)")
        cell.titleLabel.text = track.title
        cell.playIcon.text   = "▶️"
        return cell
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var track = tracks[indexPath.row]
        mediaPlayer.stop()
        mediaPlayer.contentURL = NSURL(string: track.previewUrl)
        mediaPlayer.play()
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell {
            cell.playIcon.text = "🚮"
        }

    }

    func didReceiveAPIResults(results: NSArray){
        dispatch_async(dispatch_get_main_queue(), {
            self.tracks = Track.tracksWithJSON(results)
            self.tracksTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
}
