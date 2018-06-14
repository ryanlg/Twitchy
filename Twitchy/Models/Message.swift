//
//  Message.swift
//  Twitchy
//
//  Created by Ryan Liang on 6/20/18.
//  Copyright © 2018 Ryan Liang. All rights reserved.
//

import Foundation

public struct Message: Decodable {
    
    public let body: String
    public let emoticons: [EmoticonRange]? // nil when no emo
    public let fragments: [Fragment]
    public let isAction: Bool
    public let userBadges: [UserBadge]? // can be nil
    public let userColor: String? // can be nil
    
    enum CodingKeys: String, CodingKey {
        
        case body = "body"
        case emoticons = "emoticons"
        case fragments = "fragments"
        case is_action = "is_action"
        case user_badges = "user_badges"
        case user_color = "user_color"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        body = try values.decode(String.self, forKey: .body)
        emoticons = try values.decodeIfPresent([EmoticonRange].self, forKey: .emoticons)
        fragments = try values.decode([Fragment].self, forKey: .fragments)
        isAction = try values.decode(Bool.self, forKey: .is_action)
        userBadges = try values.decodeIfPresent([UserBadge].self, forKey: .user_badges)
        userColor = try values.decodeIfPresent(String.self, forKey: .user_color)
    }
}
