//
//  Commenter.swift
//  Twitchy
//
//  Created by Ryan Liang on 6/20/18.
//  Copyright © 2018 Ryan Liang. All rights reserved.
//

import Foundation

public struct Commenter: Decodable {
    
    public let displayName: String?
    public let id: String?
    public let name: String?
    public let type: String?
    public let bio: String?
    public let created: String?
    public let updated: String?
    public let logo: String?
    
    enum CodingKeys: String, CodingKey {
        
        case displayName = "display_name"
        case id = "_id"
        case name = "name"
        case type = "type"
        case bio = "bio"
        case created = "created_at"
        case updated = "updated_at"
        case logo = "logo"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        displayName = try values.decodeIfPresent(String.self, forKey: .displayName)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        bio = try values.decodeIfPresent(String.self, forKey: .bio)
        created = try values.decodeIfPresent(String.self, forKey: .created)
        updated = try values.decodeIfPresent(String.self, forKey: .updated)
        logo = try values.decodeIfPresent(String.self, forKey: .logo)
    }
}
