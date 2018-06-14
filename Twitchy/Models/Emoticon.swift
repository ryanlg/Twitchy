//
//  Emoticon.swift
//  Twitchy
//
//  Created by Ryan Liang on 6/20/18.
//  Copyright © 2018 Ryan Liang. All rights reserved.
//

import Foundation

public struct Emoticon: Decodable {
    
    public let id: String
    public let setID: Int
    
    enum CodingKeys: String, CodingKey {
        
        case id = "emoticon_id"
        case setID = "emoticon_set_id"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        setID = try values.decode(Int.self, forKey: .setID)
    }
}
