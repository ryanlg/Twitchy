//
// Created by Ryan Liang on 5/19/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

// Games
extension Kraken {

    @discardableResult
    public static func getTopGames(completion: @escaping RegularCompletion<[Game]>) -> URLSessionDataTask? {

        let provider = Provider<KrakenEndpoint>()
        return provider.getData(.topGames) {

            result in

            guard result.isSuccess, let data = result.value else {

                if let error = result.error {
                    completion(Result.failure(error))
                } else {
                    completion(Result.failure(TwitchyError.unknown))
                }
                return
            }


            var jsonObject: Any? = nil
            do {

                jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            } catch {

                completion(Result.failure(error))
            }


            guard let json = jsonObject as? [String: Any] else {

                completion(
                    Result.failure(
                        TwitchyError.APIMismatch(
                                description: "Casting network result to dictionary returned nil.")))
                return
            }

            guard let tops = json["top"] as? [[String: Any]] else {

                completion(
                    Result.failure(
                        TwitchyError.APIMismatch(
                            description: "\"top\" field doesn't exist or type-mismatch in /games/top.")))
                return
            }

            var array: [Game] = []
            let decoder = DictionaryDecoder()
            for jsonGame in tops {

                do {

                    array.append(try decoder.decode(Game.self, from: jsonGame))
                } catch {

                    completion(
                        Result.failure(
                            TwitchyError.APIMismatch(
                                description: "Error parsing JSON returned in games/top")))
                    return
                }
            }

            completion(Result.success(array))
            return
        }
    }
}