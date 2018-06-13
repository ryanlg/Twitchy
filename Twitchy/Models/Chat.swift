//
// Created by Ryan Liang on 6/13/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

public struct Chat: Decodable {

    public let comments: [Comment]
    public let next: String

    enum CodingKeys: String, CodingKey {

        case comments = "comments"
        case next = "_next"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        comments = try values.decode([Comment].self, forKey: .comments)
        next = try values.decode(String.self, forKey: .next)
    }
}

public struct Comment: Decodable {

    public let id: String?
    public let created: String?
    public let updated: String?
    public let channelID: String?
    public let contentType: String?
    public let contentID: String?
    public let contentOffsetSeconds: Float?
    public let commenter: Commenter?
    public let source: String?
    public let state: String?
    public let message:  Message?
    public let moreReplies: Bool?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case created = "created_at"
        case updated = "updated_at"
        case channelID = "channel_id"
        case contentType = "content_type"
        case contentID = "content_id"
        case contentOffsetSeconds = "content_offset_seconds"
        case commenter
        case source = "source"
        case state = "state"
        case message
        case moreReplies = "more_replies"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        created = try values.decodeIfPresent(String.self, forKey: .created)
        updated = try values.decodeIfPresent(String.self, forKey: .updated)
        channelID = try values.decodeIfPresent(String.self, forKey: .channelID)
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

public struct Message: Decodable {

    public let body: String?
    public let emoticons: [Emoticons]?
    public let fragments: [Fragments]?
    public let isAction: Bool?
    public let userBadges: [UserBadge]?
    public let userColor: String?

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
        body = try values.decodeIfPresent(String.self, forKey: .body)
        emoticons = try values.decodeIfPresent([Emoticons].self, forKey: .emoticons)
        fragments = try values.decodeIfPresent([Fragments].self, forKey: .fragments)
        isAction = try values.decodeIfPresent(Bool.self, forKey: .is_action)
        userBadges = try values.decodeIfPresent([UserBadge].self, forKey: .user_badges)
        userColor = try values.decodeIfPresent(String.self, forKey: .user_color)
    }
}

public struct Emoticons: Decodable {

    public let id: String?
    public let begin: Int?
    public let end: Int?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case begin = "begin"
        case end = "end"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        begin = try values.decodeIfPresent(Int.self, forKey: .begin)
        end = try values.decodeIfPresent(Int.self, forKey: .end)
    }
}

public struct Fragments: Decodable {

    public let text: String?
    public let emoticon: Emoticon?

    enum CodingKeys: String, CodingKey {

        case text = "text"
        case emoticon = "emoticon"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        emoticon = try Emoticon(from: decoder)
    }
}

public struct Emoticon: Decodable {

    public let id : String?
    public let setID : Int?

    enum CodingKeys: String, CodingKey {

        case id = "emoticon_id"
        case setID = "emoticon_set_id"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        setID = try values.decodeIfPresent(Int.self, forKey: .setID)
    }
}

public struct UserBadge: Decodable {

    public let id : String?
    public let version : String?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case version = "version"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        version = try values.decodeIfPresent(String.self, forKey: .version)
    }
}
