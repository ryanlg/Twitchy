//
// Created by Ryan Liang on 5/18/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

enum KrakenEndpoint {

    // ----------
    // Games
    case topGames

    // ----------
    // Channels
    case channel(name: String)
}

extension KrakenEndpoint: Endpoint {

    var baseURL: URL {
        return URL(string: "https://api.twitch.tv/kraken")!
    }

    var path: String {

        switch self {

            case .topGames:
                return "/games/top"
            case let .channel(name):
                return "/channels/\(name)"
        }
    }

    var action: Action {

        switch self {
            default:
                return .plain
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

            default:
                return [
                    "Client-ID": Keys.shared.clientID,
                    "Accept:": "application/vnd.twitchtv.v5+json "
                ]
        }
    }
}

