//
//  Movie.swift
//  MovieSearch
//
//  Created by ac on 3/10/17.
//  Copyright © 2017 amitc. All rights reserved.
//

import Foundation
import UIKit

class Movie {
    let title:String
    let year:String
    let rated:String
    let released:String
    let director:String
    let writer:String
    let actors:String
    let plot:String
    var poster:UIImage?
    let posterURL:String
    let metascore:String
    let imdbRating:String
    let imdbID:String

    init(dictionary:[String:String]) {
            title = dictionary["Title"] ?? "NA"
            year = dictionary["Year"] ?? "NA"
            rated = dictionary["Rated"] ?? "NA"
            released = dictionary["Released"] ?? "NA"
            director = dictionary["Director"] ?? "NA"
            writer  = dictionary["Writer"] ?? "NA"
            actors = dictionary["Actors"] ?? "NA"
            plot = dictionary["Plot"] ?? "NA"
            metascore = dictionary["Metascore"] ?? "NA"
            imdbRating = dictionary["imdbRating"] ?? "NA"
            imdbID = dictionary["imdbID"] ?? "NA"
            posterURL = dictionary["Poster"] ?? "NA"
    }
    
}
