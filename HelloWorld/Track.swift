//
//  Track.swift
//  HelloWorld
//
//  Created by hiroyukky on 6/12/15.
//  Copyright © 2015 hiroyukky. All rights reserved.
//

import Foundation

struct Track {
    let title: String
    let price: String
    let previewUrl: String
    init(title: String, price: String, previewUrl: String) {
        self.title      = title
        self.price      = price
        self.previewUrl = previewUrl
    }
    static func tracksWithJSON(results: NSArray) -> [Track]{
        var tracks = [Track]()
        for trackInfo in results {
            //print("trackInfo : \(trackInfo.description)")
            if let kind = trackInfo["kind"] as? String {
                if kind == "song" {
                    var trackPrice = trackInfo["trackPrice"] as? String
                    var trackTitle = trackInfo["trackName"] as? String
                    var trackPreviewUrl = trackInfo["previewUrl"] as? String
                    if(trackTitle == nil) {
                        trackTitle = "Unkown"
                    }
                    if trackPrice == nil {
                        trackPrice = ""
                    }
                    if trackPreviewUrl == nil {
                        trackPreviewUrl = ""
                    }
                    var track = Track(title: trackTitle!, price: trackPrice!, previewUrl: trackPreviewUrl!)
                    tracks.append(track)
                }
            }
        }
        return tracks
    }
}