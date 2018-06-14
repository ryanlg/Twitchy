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
