//
//  Movie.swift
//  Flick
//
//  Created by mac on 8/14/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

class Movie: NSObject {
    var title: String!
    var overview: String!
    var imageUrlString: String!
    var posterUrlString: String!
    
    init(dictionary: NSDictionary) {
        title = dictionary["title"] as! String
        overview = dictionary["overview"] as! String
        imageUrlString = "https://image.tmdb.org/t/p/w342" + (dictionary["poster_path"] as! String)
        posterUrlString = "https://image.tmdb.org/t/p/original" + (dictionary["poster_path"] as! String)
    }
    
    class func moviesWithArray(array: [NSDictionary]) -> [Movie] {
        var movies = [Movie]()
        
        for dict in array {
            movies.append(Movie(dictionary: dict))
        }
        return movies
    }
}
