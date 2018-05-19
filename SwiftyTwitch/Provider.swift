//
// Created by Ryan Liang on 5/19/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

open class Provider<Target: Endpoint> {

    open func getData(_ target: Target, completionHandler: @escaping (Result<Data>) -> Void) -> URLSessionDataTask? {

        do {

            let request = try target.urlRequest()
            let task = URLSession.shared.dataTask(with: request) {

                data, request, error in

                if let error = error, let _ = data {

                    completionHandler(Result.failure(error))
                    return
                }

                completionHandler(Result.success(data!))
            }

            task.resume()
            return task
        } catch {

            completionHandler(Result.failure(error))
        }

        return nil
    }
}
