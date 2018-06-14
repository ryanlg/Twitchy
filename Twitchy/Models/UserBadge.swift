//
//  UserBadge.swift
//  Twitchy
//
//  Created by Ryan Liang on 6/20/18.
//  Copyright © 2018 Ryan Liang. All rights reserved.
//

import Foundation

public struct UserBadge: Decodable {
    
    public let id: String
    public let version: String
    
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        case version = "version"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        version = try values.decode(String.self, forKey: .version)
    }
}
