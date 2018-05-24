//
// Created by Ryan Liang on 5/26/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

public struct AccessToken {

    let token: String
    let signature: String
    // let mobileRestricted: Bool // Commented since it seems unused
}

extension AccessToken: Decodable {

    public init(from decoder: Decoder) throws {

        let value = try decoder.container(keyedBy: CodingKeys.self)

        token = try value.decode(String.self, forKey: .token)
        signature = try value.decode(String.self, forKey: .signature)
    }

    enum CodingKeys: String, CodingKey {

        case token
        case signature = "sig"
        case mobileRestricted = "mobile_restricted"
    }
}