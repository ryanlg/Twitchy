//
// Created by Ryan Liang on 5/26/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

/// Private endpoint
enum PrivateEndpoint {

    case streamAccessToken(forChannel: String)
    case streamPlaylist(forChannel: String, token: String, signature: String)

    /// Chat records for VODs.
    /// @params:
    ///  isSecond: when this is true, offset is the location of the beginning of the chat log, in seconds.
    ///            when it is false, it is the cursor returned with your previous request.
    case vodChatReplay(id: String, offset: String, isSecond: Bool)
}

/// Conform to endpoint
extension PrivateEndpoint: Endpoint {

    var baseURL: URL {

        switch self {
            case .streamAccessToken:
                return URL(string: "https://api.twitch.tv/api")!
            case .streamPlaylist:
                return URL(string: "https://usher.ttvnw.net/api")!
            case .vodChatReplay:
                return URL(string: "https://api.twitch.tv/v5")!
        }
    }

    var path: String {

        switch self {
            case let .streamAccessToken(forChannel: channel):
                return "/channels/\(channel)/access_token"
            case let .streamPlaylist(forChannel: channel, token: _, signature: _):
                return "/channel/hls/\(channel).m3u8"
            case let .vodChatReplay(id: id, offset: _, isSecond: _):
                return "/videos/\(id)/comments"
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
            case let .vodChatReplay(id: _, offset: offset, isSecond: isSecond):
                if isSecond {
                    return .parameters(parameters: [
                        "content_offset_seconds": offset
                    ])
                } else {
                    return .parameters(parameters: [
                        "cursor": offset
                    ])
                }
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
            default:
                return [
                    "Client ID": Keys.shared.clientID
                ]
        }
    }
}
