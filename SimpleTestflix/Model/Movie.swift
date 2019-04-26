//
//  Movie.swift
//  SimpleTestflix
//
//  Created by Victor Valfre on 25/04/19.
//  Copyright © 2019 Victor Valfre. All rights reserved.
//

import Foundation

public class Movies: Codable {
    public var values: [Movie]?
    public var page: Int?
    public var total_pages: Int?
    public var genders: [Gender]?
    
    enum CodingKeys: String, CodingKey
    {
        case values = "results"
        case page = "page"
        case total_pages = "total_pages"
    }
    
    public init (){
        self.page = 0
        self.total_pages = 0
        self.values = []
        self.genders = []
    }
    
    public func parseDate(){
        self.values?.forEach { (value) in
            value.parseDate()
        }
    }
    
    public func sortByDate( asc: Bool ){
        if(self.values != nil){
            self.values = self.values!.sorted(by: { $0.rDate!.compare($1.rDate!) == (asc ? .orderedAscending : .orderedDescending) })
        }
    }
    
    public func parseGender(){
        self.values!.forEach {
            (movie) in
            movie.parseGender(genders: self.genders!)
        }
    }
}

public class Movie : Codable {
    public var voteCount: Int?
    public var id: Int?
    public var video: Bool?
    public var voteAverage: Float?
    public var title: String?
    public var popularity: Float?
    public var posterPath: String?
    public var originalLanguage: String?
    public var originalTitle: String?
    public var idGender: [Int]?
    public var backDropPath: String?
    public var adult: Bool?
    public var overview: String?
    public var releaseDate: String?
    public var rDate: Date?
    public var rGender: [String]?
    
    enum CodingKeys: String, CodingKey
    {
        case voteCount = "vote_count"
        case id = "id"
        case video = "video"
        case voteAverage = "vote_average"
        case title = "title"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case idGender = "genre_ids"
        case backDropPath = "backdrop_path"
        case adult = "adult"
        case overview = "overview"
        case releaseDate = "release_date"
    }
    
    public func parseDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.rDate = dateFormatter.date(from:self.releaseDate!)!
    }
    
    public func parseGender(genders: [Gender]){
        
        if(self.idGender != nil && self.idGender!.count > 0){
            self.idGender!.forEach { (id) in
                let selectedGender = genders.filter({ $0.id == id})
                
                selectedGender.forEach { (sg) in
                    let name = sg.name != nil ? sg.name! : ""
                    if(self.rGender == nil){
                        self.rGender = [String]()
                    }
                    if(!(self.rGender!.contains(name)) ){
                        self.rGender!.append(name)
                    }
                }
            }
        }
    }
}
