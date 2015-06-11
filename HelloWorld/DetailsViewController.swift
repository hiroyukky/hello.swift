//
//  DetailsViewController.swift
//  HelloWorld
//
//  Created by hiroyukky on 6/11/15.
//  Copyright © 2015 hiroyukky. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    var album: Album?
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    required init(coder aDecorder: NSCoder) {
        super.init(coder: aDecorder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageURL)!)!)
        titleLabel.text = self.album?.title
        
    }

}
