//
// Created by Ryan Liang on 5/19/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

/// Kraken helpers, not API related
extension Kraken {

    internal static func resultCheckRegular<Type>(_ result: Result<Type>, _ response: URLResponse?) throws {

        if result.isFailure {

            if result.error != nil {
                throw result.error!
            } else  {
                throw TwitchyError.responseCheck(reason: .missingError)
            }
        }

        // check optional here so that we can force unwrap it after this call
        guard let _ = result.value else { throw TwitchyError.responseCheck(reason: .missingValue) }

        guard let response = response as? HTTPURLResponse else { throw TwitchyError.responseCheck(reason: .missingResponse) }

        let status = response.statusCode
        if status < 200 || status > 300 {

            var jsonAny: Any? = result.value
            if let jsonData = result.value as? Data {
                do {
                    jsonAny = try JSONSerialization.jsonObject(with: jsonData)
                } catch {
                    throw TwitchyError.responseCheck(reason: .messageParsingFailed(payload: "\(response)"))
                }
            }

            guard let json = jsonAny as? [String: Any],
                  let error = json["error"] as? String,
                  let message = json["message"] as? String else {

                throw TwitchyError.responseCheck(reason: .messageParsingFailed(payload: "\(response)"))
            }

            throw TwitchyError.statusCode(status, error: error, message: message)
        }
    }
}
