//
//  Movie.swift
//  Movie-Finder
//
//  Created by Ahmed Sayed on 11/2/20.
//  Copyright © 2020 Ahmed Sayed. All rights reserved.
//

import Foundation


// called data hierarchy
struct MovieResult: Codable {
    let Search: [Movie]
}

struct Movie: Codable {
    let Title: String
    let Year: String
    let imdbID: String
    let _Type: String
    let Poster: String
    
    //Since "Type" is reserved, so..
    private enum CodingKeys: String,CodingKey {
        case Title, Year, imdbID, _Type = "Type", Poster
    }
    
}
