//
// Created by Ryan Liang on 5/22/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation
import Cocoa

extension Kraken {

    /// Returns the absolute URL for oauth
    /// You can use this to construct a URL to open in local browser
    public static func oauth2AbsoluteURL(redirectURI: String,
                                         scope: Scopes,
                                         responseType: AuthResponseType = .token,
                                         forceVerify: Bool? = nil,
                                         state: String? = nil) -> URL {

        let target = KrakenEndpoint.oauth2(redirectURI: redirectURI,
                responseType: responseType,
                scope: scope,
                forceVerify: forceVerify,
                state: state)

        do {

            return try target.urlRequest().url!
        } catch {

            // should not happen
            fatalError(error.localizedDescription)
        }
    }
}
