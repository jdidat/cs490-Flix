//
//  Movie.swift
//  Flix
//
//  Created by Jackson Didat on 2/12/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import Foundation
class Movie {
    
    var title: String
    var posterUrl: URL?
    var overview: String
    var rating: Double
    var posterPathString: String
    var backdropPathString: String
    var releaseDate: String
    var movieId: Int
    
    init(dictionary: [String: Any]) {
        title = dictionary["title"] as? String ?? "No title"
        posterUrl = dictionary["poster_url"] as? URL
        overview = dictionary["overview"] as! String
        rating = dictionary["vote_average"] as! Double
        rating = rating / 2
        posterPathString = dictionary["poster_path"] as! String
        backdropPathString = dictionary["backdrop_path"] as! String
        movieId = dictionary["id"] as! Int
        releaseDate = dictionary["release_date"] as! String
    }
    
    class func movies(dictionaries: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []
        for dictionary in dictionaries {
            let movie = Movie(dictionary: dictionary)
            movies.append(movie)
        }
        
        return movies
    }
}
