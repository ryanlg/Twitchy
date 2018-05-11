//
// Created by Ryan Liang on 5/18/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

enum Kraken {

    case topGames
}

extension Kraken: Endpoint {

    var baseURL: URL {
        return URL(string: "https://api.twitch.tv/kraken")!
    }

    var path: String {

        switch self {
            case .topGames:
                return "/games/top"
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
                    "Client-ID": Keys.shared.clientID
                ]
        }
    }
}

