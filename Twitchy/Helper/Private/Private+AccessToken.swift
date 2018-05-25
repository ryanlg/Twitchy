//
// Created by Ryan Liang on 5/26/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

extension Private {

    public static func getStreamAccessToken(forChannel: String, completion: @escaping RegularCompletion<AccessToken>) {

        regularProvider.getData(.streamAccessToken(forChannel: forChannel)) {

            result, response in

            do {
                try resultCheckRegular(result, response)
            } catch {
                completion(Result.failure(error))
                return
            }

            do {

                let data = result.value!
                let decoder = JSONDecoder()
                let accessToken = try decoder.decode(AccessToken.self, from: data)

                completion(Result.success(accessToken))
            } catch {

                completion(
                        Result.failure(
                                TwitchyError.APIMismatch(description: "getStreamAccessToken(forChannel:)")))
                return
            }
        }
    }
}
