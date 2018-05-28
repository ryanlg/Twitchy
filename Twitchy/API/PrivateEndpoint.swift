//
// Created by Ryan Liang on 5/26/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

enum PrivateEndpoint {

    case streamAccessToken(forChannel: String)
    case streamPlaylist(forChannel: String, token: String, signature: String)
}

extension PrivateEndpoint: Endpoint {

    var baseURL: URL {

        switch self {
            case .streamAccessToken:
                return URL(string: "https://api.twitch.tv/api")!
            case .streamPlaylist:
                return URL(string: "https://usher.ttvnw.net/api")!
        }
    }

    var path: String {

        switch self {
            case let .streamAccessToken(forChannel: channel):
                return "/channels/\(channel)/access_token"
            case let .streamPlaylist(forChannel: channel, token: _, signature: _):
                return "/channel/hls/\(channel).m3u8"
        }
    }

    var action: Action {

        switch self {
            case .streamAccessToken:
                return .parameters(parameters: [
                    "client_id": Keys.shared.clientID
                ])
            case let .streamPlaylist(forChannel: _, token: token, signature: sig):
                return .parameters(parameters: [
                    "token": token,
                    "sig": sig
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
            case .streamAccessToken, .streamPlaylist:
                return [:]
        }
    }
}
