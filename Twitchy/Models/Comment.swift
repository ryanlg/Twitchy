//
//  Commenter.swift
//  Twitchy
//
//  Created by Ryan Liang on 6/20/18.
//  Copyright © 2018 Ryan Liang. All rights reserved.
//

import Foundation

public struct Comment: Decodable {
    
    public let id: String
    public let created: String
    public let updated: String
    public let channelID: String
    public let contentType: String?
    public let contentID: String?
    public let contentOffsetSeconds: Float?
    public let commenter: Commenter
    public let source: String?
    public let state: String?
    public let message:  Message
    public let moreReplies: Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        case created = "created_at"
        case updated = "updated_at"
        case channelID = "channel_id"
        case contentType = "content_type"
        case contentID = "content_id"
        case contentOffsetSeconds = "content_offset_seconds"
        case commenter = "commenter"
        case source = "source"
        case state = "state"
        case message = "message"
        case moreReplies = "more_replies"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        created = try values.decode(String.self, forKey: .created)
        updated = try values.decode(String.self, forKey: .updated)
        channelID = try values.decode(String.self, forKey: .channelID)
        contentType = try values.decodeIfPresent(String.self, forKey: .contentType)
        contentID = try values.decodeIfPresent(String.self, forKey: .contentID)
        contentOffsetSeconds = try values.decodeIfPresent(Float.self, forKey: .contentOffsetSeconds)
        commenter = try Commenter(from: decoder)
        source = try values.decodeIfPresent(String.self, forKey: .source)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        message = try Message(from: decoder)
        moreReplies = try values.decodeIfPresent(Bool.self, forKey: .moreReplies)
    }
}
