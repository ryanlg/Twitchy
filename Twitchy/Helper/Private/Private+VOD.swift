//
// Created by Ryan Liang on 6/13/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

extension Private {

    public static func vodChatReplay(vodID: String, offsetInSeconds: String, completion: @escaping RegularCompletion<Chat>) {

        regularProvider.getData(.vodChatReplay(id: vodID, offset: offsetInSeconds, isSecond: true)) {

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
                let accessToken = try decoder.decode(Chat.self, from: data)

                completion(Result.success(accessToken))
            } catch {

                completion(
                        Result.failure(
                                TwitchyError.APIMismatch(description: "vodChatReplay failed")))
                return
            }
        }
    }
//
//    public static func vodChatReplay(vodID: String, cursor: String) {
//
//    }
}