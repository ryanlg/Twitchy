//
// Created by Ryan Liang on 5/19/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

/// Helpers, not API related
extension Private {

    /// Check the result whether it
    /// 1. has any error
    /// 2. has no error but has no value
    /// 3. has no error, has value, but wrong status code (Twitch returned error JSON)
    internal static func resultValidateRegular<Type>(_ result: Result<Type>, _ response: URLResponse?) throws {

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

    /// Check the result whether it
    /// 1. has any error
    /// 2. has no error but has no value
    /// 3. has no error, has value, but wrong status code (Twitch returned error HTML)
    /// * This method is specifically for validating playlist
    internal static func resultValidatePlaylist<Type>(_ result: Result<Type>, _ response: URLResponse?) throws {

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

            if let stringData = result.value as? Data,
               let message = String(data: stringData, encoding: .utf8) {
                
                var parsed: (String, String)?
                do {

                    parsed = try parsePlaylistErrorHTML(message)
                    
                } catch {

                    throw TwitchyError.responseCheck(reason: .messageParsingFailed(payload: "\(response)"))
                }
                
                throw TwitchyError.statusCode(status, error: parsed!.1, message: parsed!.0)
            } else {

                throw TwitchyError.responseCheck(reason: .messageParsingFailed(payload: "\(response)"))
            }
        }
    }

    /// Parsing playlist error html
    private static func parsePlaylistErrorHTML(_ html: String) throws -> (String, String) {

        // getting url
        // fixed: <table border=\"1\"><tr><td><b>url</b></td><td> (47 chars)
        let chunk1 = html[html.index(html.startIndex, offsetBy: 46)...]

        // find the next </td>
        var url: String?
        for i in 0 ... (chunk1.count - 1) {

            let char = chunk1[chunk1.index(chunk1.startIndex, offsetBy: i)]

            if char == "<" {

                url = String(chunk1[..<chunk1.index(chunk1.startIndex, offsetBy: i)])
                break
            }
        }

        guard let unwrappedURL = url else { throw TwitchyError.responseCheck(reason: .messageParsingFailed(payload: html)) }

        // find </td></tr></table> (18 char) from the back
        let chunk2 = html[..<html.index(html.endIndex, offsetBy: -18)]

        var message: String?
        for i in 1 ... (chunk2.count) {

            let char = chunk2[chunk2.index(chunk2.endIndex, offsetBy: -i)]

            if char == ">" {

                message = String(chunk2[chunk2.index(chunk2.endIndex, offsetBy: -i + 1)...])
                break
            }
        }

        guard let unwrappedMessage = message else { throw TwitchyError.responseCheck(reason: .messageParsingFailed(payload: html)) }

        return (unwrappedURL, unwrappedMessage)
    }
}
