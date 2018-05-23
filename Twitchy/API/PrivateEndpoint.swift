//
// Created by Ryan Liang on 5/26/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

enum Private {

    enum Stream {

        case accessToken(forChannel: String)
    }
}

extension Private.Stream: Endpoint {

    var baseURL: URL {

        switch self {
            case .accessToken:
                return URL(string: "https://api.twitch.tv/api/")!
        }
    }

    var path: String {

        switch self {
            case let .accessToken(forChannel: channel):
                return "/channel/\(channel)/access_token"
        }
    }

    var action: Action {

        switch self {
            case .accessToken:
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
            case .accessToken:
                return [:]
        }
    }
}
