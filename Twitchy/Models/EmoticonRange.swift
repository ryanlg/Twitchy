//
//  Emoticons.swift
//  Twitchy
//
//  Created by Ryan Liang on 6/20/18.
//  Copyright © 2018 Ryan Liang. All rights reserved.
//

import Foundation

public struct EmoticonRange: Decodable {
    
    public let id: String
    public let begin: Int
    public let end: Int
    
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        case begin = "begin"
        case end = "end"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        begin = try values.decode(Int.self, forKey: .begin)
        end = try values.decode(Int.self, forKey: .end)
    }
}
