//
// Created by Ryan Liang on 5/22/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation
import Cocoa

extension Kraken {

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

    // @todo: add ios solution
    public static func oauth2(redirectURI: String,
                              scope: Scopes,
                              responseType: AuthResponseType = .token,
                              forceVerify: Bool? = nil,
                              state: String? = nil) {


        let url = oauth2AbsoluteURL(redirectURI: redirectURI,
                                    scope: scope,
                                    responseType: responseType,
                                    forceVerify: forceVerify,
                                    state: state)

        NSWorkspace.shared.open(url)
    }
}
