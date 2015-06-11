//
//  Album.swift
//  HelloWorld
//
//  Created by hiroyukky on 6/11/15.
//  Copyright © 2015 hiroyukky. All rights reserved.
//

import Foundation

class Album{
    let title: String
    let price: String
    let thumbnailImageURL: String
    let largeImageURL: String
    let itemURL: String
    let artistURL: String

    init(title: String, price: String, thumbnailImageURL: String, largeImageURL: String, itemURL: String, artistURL: String) {
        self.title = title
        self.price = price
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.itemURL = itemURL
        self.artistURL = artistURL
    }

    static func albumsWithJSON(results: NSArray) -> [Album] {
        var albums = [Album]()
        if (results.count) > 0 {
            for result in results {
                var name = result["trackName"] as? String
                if name == nil {
                    name = result["collectionName"] as? String
                }
                var price = result["formattedPrice"] as? String
                if price == nil {
                    price = result["collectionPrice'"] as? String
                    if price == nil {
                        var priceFloat: Float? = result["collectionPrice"] as? Float
                        var nf: NSNumberFormatter = NSNumberFormatter()
                        nf.maximumFractionDigits = 2
                        if priceFloat != nil {
                            price = "$\(nf.stringFromNumber(priceFloat!)!)"
                        }
                    }
                }
                let thumbnailImageURL = result["artworkUrl60"]  as? String ?? ""
                let imageURL          = result["artworkUrl100"] as? String ?? ""
                let artistURL         = result["artistViewUrl"] as? String ?? ""
                var itemURL = result["collectionViewUrl"] as? String
                if itemURL == nil {
                    itemURL = result["trackViewUrl"] as? String
                }
                var newAlbum = Album(title: name!, price: price!, thumbnailImageURL: thumbnailImageURL, largeImageURL: imageURL, itemURL: itemURL!, artistURL: artistURL)
                albums.append(newAlbum)
            }
        }
        return albums
    }
}