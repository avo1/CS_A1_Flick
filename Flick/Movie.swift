//
//  Movie.swift
//  Flick
//
//  Created by mac on 8/14/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class Movie: Object {
    // Make sure to inherrit the class from NSObject, NScoding
    // only then you can archive
    dynamic var title = ""
    dynamic var overview = ""
    dynamic var posterUrlString = ""

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(posterUrlString, forKey: "posterPath")
        aCoder.encodeObject(overview, forKey: "overview")
    }
    
    convenience init(coder aDecoder: NSCoder) {
        self.init()
        title = aDecoder.decodeObjectForKey("title") as! String
        overview = aDecoder.decodeObjectForKey("overview") as! String
        posterUrlString = aDecoder.decodeObjectForKey("posterPath") as! String
    }

    convenience init(dictionary: NSDictionary) {
        self.init()
        title = dictionary["title"] as! String
        overview = dictionary["overview"] as! String
        if let url = dictionary["poster_path"] as? String {
            posterUrlString = "https://image.tmdb.org/t/p/w342" + url
        } else {
            posterUrlString = "https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg"
        }
    }

    class func moviesWithArray(array: [NSDictionary]) -> [Movie] {
        var movies = [Movie]()
        
        for dict in array {
            movies.append(Movie(dictionary: dict))
        }
        return movies
    }
}
