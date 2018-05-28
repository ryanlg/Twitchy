//
// Created by Ryan Liang on 5/19/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

extension Kraken {

    /// Get channel infos
    /// This is just for infos. For stream data, see private APIs
    public static func getChannel(withName name: String, completion: @escaping RegularCompletion<Channel>) {

        regularProvider.getData(.channel(name: name)) {

            result, response in

            do {

                try resultCheckRegular(result, response)
            } catch {

                completion(Result.failure(error))
                return
            }

            do {

                let decoder = JSONDecoder()
                let channel = try decoder.decode(Channel.self, from: result.value!)

                completion(Result.success(channel))
            } catch {

                completion(
                        Result.failure(
                                TwitchyError.APIMismatch(description: "getChannel(withName:)")))
                return
            }
        }
    }
}
