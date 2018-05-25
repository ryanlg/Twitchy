//
// Created by Ryan Liang on 5/26/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

enum PrivateEndpoint {


    case streamAccessToken(forChannel: String)
}

extension PrivateEndpoint: Endpoint {

    var baseURL: URL {

        switch self {
            case .streamAccessToken:
                return URL(string: "https://api.twitch.tv/api")!
        }
    }

    var path: String {

        switch self {
            case let .streamAccessToken(forChannel: channel):
                return "/channels/\(channel)/access_token"
        }
    }

    var action: Action {

        switch self {
            case .streamAccessToken:
                return .parameters(parameters: [
                    "client_id": Keys.shared.clientID
                ])
        }
    }

    var method: HTTPMethod {

        switch self {
            default:
                return .get
        }
    }

    var headers: HTTPHeaders? {

        switch self {
            case .streamAccessToken:
                return [:]
        }
    }
}
