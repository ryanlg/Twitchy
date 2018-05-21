//
// Created by Ryan Liang on 5/19/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

// Helpers, not API related
extension Kraken {

    internal static func resultCheckRegular<Type>(_ result: Result<Type>, _ response: URLResponse?) throws {

        if result.isFailure {

            if result.error != nil {
                throw result.error!
            } else  {
                throw TwitchyError.unknown
            }
        }

        // check optional here so that we can force unwrap after this call
        // I don't know what error this should be so leaving it as unknown
        guard let _ = result.value else { throw TwitchyError.unknown }

        guard let response = response as? HTTPURLResponse else { throw TwitchyError.unknown }

        // @todo: refine status code logic
        let status = response.statusCode
        if status < 200 || status > 300 {

            var jsonAny: Any? = result.value
            if let jsonData = result.value as? Data {
                do {
                    jsonAny = try JSONSerialization.jsonObject(with: jsonData)
                } catch {
                    throw TwitchyError.unknown
                }
            }
            guard let json = jsonAny as? [String: Any],
                  let error = json["error"] as? String,
                  let message = json["message"] as? String else {

                throw TwitchyError.unknown
            }
            throw TwitchyError.statusCode(status, error: error, message: message)
        }
    }
}
