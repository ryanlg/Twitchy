//
// Created by Ryan Liang on 5/14/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

/// Represents a channel returned from Kraken API
public struct Channel: Decodable {

    let id: Int
    let name: String
    let logo: String
    let views: Int
    let followers: Int
    let displayName: String

    let game: String

    let mature: Bool
    let status: String
    let partner: Bool

    let language: String
    let broadcasterLanguage: String

    let createdAt: String
    let updatedAt: String

    let videoBanner: String
    let profileBanner: String

    let url: String

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case name
        case logo
        case views
        case followers
        case displayName = "display_name"

        case game

        case mature
        case status
        case partner

        case language
        case broadcasterLanguage = "broadcaster_language"

        case createdAt = "created_at"
        case updatedAt = "updated_at"

        case videoBanner = "video_banner"
        case profileBanner = "profile_banner"

        case url
    }
}
