//
// Created by Ryan Liang on 5/18/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

enum KrakenEndpoint {

    // ----------
    // Auth
    case oauth2(redirectURI: String,
                responseType: AuthResponseType,
                scope: Scopes,
                forceVerify: Bool?,
                state: String?)

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
            case .oauth2:
                return "/oauth2/authorize"
        }
    }

    var action: Action {

        switch self {
            case let .oauth2(redirectURI, responseType, scope, forceVerify, state):

                var param: [String: Any] = ["client_id": Keys.shared.clientID,
                                            "redirect_uri": redirectURI,
                                            "response_type": responseType,
                                            "scope": scope]

                if let forceVerify = forceVerify { param["force_verify"] = forceVerify }
                if let state = state { param["state"] = state }

                return .parameters(parameters: param)

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

            case .oauth2:
                return [
                    "Accept:": "application/vnd.twitchtv.v5+json "
                ]

            default:
                return [
                    "Client-ID": Keys.shared.clientID,
                    "Accept:": "application/vnd.twitchtv.v5+json "
                ]
        }
    }
}

