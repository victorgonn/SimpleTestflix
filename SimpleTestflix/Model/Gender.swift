//
//  Gender.swift
//  SimpleTestflix
//
//  Created by Victor Valfre on 25/04/19.
//  Copyright © 2019 Victor Valfre. All rights reserved.
//

import Foundation

public class Genders : Codable {
    public var values: [Gender]
    
    enum CodingKeys: String, CodingKey
    {
        case values = "genres"
    }
    
    public init (){
        self.values = []
    }
}


public class Gender : Codable {
    public var id: Int?
    public var name: String?
    
    public init (id: Int, name: String){
        self.id = id
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id = "id"
        case name = "name"
    }
}
