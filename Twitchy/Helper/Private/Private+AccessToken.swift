//
// Created by Ryan Liang on 5/26/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

/// Access Token & Playlist related
extension Private {

    /// Get stream access token
    /// Returns a AccessToken struct
    public static func getStreamAccessToken(forChannel: String, completion: @escaping RegularCompletion<AccessToken>) {

        regularProvider.getData(.streamAccessToken(forChannel: forChannel)) {

            result, response in

            do {
                try resultValidateRegular(result, response)
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


    /// Get stream .m3u playlist
    /// This playlist is the one with locations of different bitrate of streams
    public static func getStreamPlaylist(forChannel: String,
                                         token: String,
                                         signature: String,
                                         completion: @escaping RegularCompletion<Data>) {

        regularProvider.getData(.streamPlaylist(forChannel: forChannel,
                                                token: token,
                                                signature: signature)) {

            result, response in

            do {
                try resultValidatePlaylist(result, response)
            } catch {
                completion(Result.failure(error))
                return
            }

            completion(Result.success(result.value!))
        }
    }
}
